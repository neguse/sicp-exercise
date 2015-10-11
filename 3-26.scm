#lang racket
(require r5rs)

; まずデータ構造を考えましょう
; Tree : (Node) | (Object)
; Node : (Entry Node Node) | Nil
; Entry : (Key Tree)
; Key : Object
; こんな感じに再帰的になってればたぶん大丈夫なんじゃないか

;; entry
(define (make-entry key value) (list 'entry key value))
(define (assert-entry entry)
  (if (not (equal? 'entry (car entry))) (error 'not-entry)))
(define (entry-key entry) (assert-entry entry) (cadr entry))
(define (entry-value entry) (assert-entry entry) (caddr entry))
(define (entry-set-value! entry) (assert-entry entry) (set-car! (cddr entry)))

;; node
(define (make-node entry left right) (list 'node entry left right))
(define (assert-node node)
  (if (not (equal? 'node (car node))) (error 'not-node)))
(define (node-entry node) (assert-node node) (cadr node))
(define (node-entry-key node) (assert-node node) (entry-key (node-entry node)))
(define (node-entry-value node) (assert-node node) (entry-value (node-entry node)))
(define (node-left node) (assert-node node) (caddr node))
(define (node-right node) (assert-node node) (cadddr node))
(define (node-set-entry node) (assert-node node) (set-car! (cdr node)))
(define (node-set-left! node left) (assert-node node) (set-car! (cddr node) left))
(define (node-set-right! node right) (assert-node node) (set-car! (cdddr node) right))

;; tree

(define (make-tree node) (list 'tree node))
(define (assert-tree tree)
  (if (not (equal? 'tree (car tree))) (error 'not-tree)))
(define (tree-node tree) (assert-tree tree) (cadr tree))
(define (set-tree-node! tree node) (assert-tree tree) (set-car! (cdr tree) node))

; returns found node or false
(define (assoc-tree tree key)
  (define (assoc-tree-iter node key)
	(if (null? node) false
	  (let ((node-key (node-entry-key node)))
		(cond
		  ((equal? node-key key) node)
		  ((< node-key key) (assoc-tree-iter (node-left node) key))
		  ((> node-key key) (assoc-tree-iter (node-right node) key))))))
  (assoc-tree-iter (tree-node tree) key))

; return found tree or found value or false
(define (assoc-tree* tree keys)
  (if (null? keys)
	(tree-node tree)
	(let ((node (assoc-tree tree (car keys))))
	  (if (not node)
		false
		(assoc-tree* (node-entry-value node) (cdr keys))))))

;
(define (insert-tree! tree key value)
  (define (insert-tree-iter! node key value)
	(if (null? node) (make-node (make-entry key value) '() '())
	  (let ((node-key (node-entry-key node)))
		(cond
		  ((equal? node-key key)
		   (entry-set-value! (node-entry node) value)
		   node)
		  ((< node-key key)
		   (node-set-left! node (insert-tree-iter! (node-left node) key value))
		   node)
		  ((> node-key key)
		   (node-set-right! node (insert-tree-iter! (node-right node) key value))
		   node)))))
  (set-tree-node! tree (insert-tree-iter! (tree-node tree) key value)))

; always returns 'ok
(define (make-one-node-tree* keys value)
  (if (null? keys)
	(make-tree value)
	(make-tree
	  (make-node
		(make-entry (car keys) (make-one-node-tree* (cdr keys) value)) '() '()))))

(define (insert-tree*! tree keys value)
  (if (null? keys) (set-tree-node! tree value)
	(let ((a (assoc-tree tree (car keys))))
	  (cond
		(a (insert-tree*! (node-entry-value a) (cdr keys) value))
		(else
		  (insert-tree! tree (car keys) (make-one-node-tree* (cdr keys) value)))))))

(define (make-table)
  (let ((local-tree (make-tree '())))
	(define (lookup keys)
	  (assoc-tree* local-tree keys))
	(define (insert! keys value)
	  (insert-tree*! local-tree keys value))
	(define (p)
	  (display local-tree))
	(define (dispatch m)
	  (cond ((eq? m 'lookup-proc) lookup)
			((eq? m 'insert-proc!) insert!)
			((eq? m 'print) p)
			(else (error "Unknown operation -- TABLE" m))))
	dispatch))

(define operation-table (make-table))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))
(define p (operation-table 'print))

(put '(1) 1)
(put '(3) 3)
(put '(2) 2)
(put '(5 4) 20)
(p) (newline)
(get '(1))
(get '(2))
(get '(3))
(get '(5 4))

; エラーチェック全然できてない。
; もうちょっとなんとかなる気がする。

