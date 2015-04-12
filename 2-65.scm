#lang racket

; 木->リスト->集合演算->木
; という処理をやればいいらしい
; が、それでいいのか…

(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
        (let ((left-result (partial-tree elts left-size)))
          (let ((left-tree (car left-result))
                (non-left-elts (cdr left-result))
                (right-size (- n (+ left-size 1))))
            (let ((this-entry (car non-left-elts))
                  (right-result (partial-tree (cdr non-left-elts)
                                              right-size)))
              (let ((right-tree (car right-result))
                    (remaining-elts (cdr right-result)))
                (cons (make-tree this-entry left-tree right-tree)
                      remaining-elts))))))))

(define (tree->list tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
        result-list
        (copy-to-list (left-branch tree)
                      (cons (entry tree)
                            (copy-to-list (right-branch tree)
                                          result-list)))))
  (copy-to-list tree '()))

(define (tree-op op tree1 tree2)
  (let
	((set1 (tree->list tree1))
	(set2 (tree->list tree2)))
	(let
	  ((result (op set1 set2)))
		(list->tree result))))

(define (tree-union-set tree1 tree2)
  (tree-op list-union-set tree1 tree2))

(define (tree-intersection-set tree1 tree2)
  (tree-op list-intersection-set tree1 tree2))

(define (list-union-set set1 set2)
  (cond
	((null? set1) set2)
	((null? set2) set1)
	(else
	  (let ((x1 (car set1)) (x2 (car set2)))
		(cond
		  ((= x1 x2)
		   (cons x1 (list-union-set (cdr set1) (cdr set2))))
		  ((< x1 x2)
		   (cons x1 (list-union-set (cdr set1) set2)))
		  (else
			(cons x2 (list-union-set set1 (cdr set2)))))))))

(define (list-intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()    
      (let ((x1 (car set1)) (x2 (car set2)))
        (cond ((= x1 x2)
               (cons x1
                     (list-intersection-set (cdr set1)
                                       (cdr set2))))
              ((< x1 x2)
               (list-intersection-set (cdr set1) set2))
              ((< x2 x1)
               (list-intersection-set set1 (cdr set2)))))))

(define (union-set2 l1 l2)
  (tree->list (tree-union-set (list->tree l1) (list->tree l2))))

(union-set2 '(1 2 3) '())
(union-set2 '() '(1 2 3))

(union-set2 '(1 3) '(2 4))
(union-set2 '(1 3 5) '(2 4))
(union-set2 '(2 4) '(1 3))
(union-set2 '(2 4) '(1 3 5))

(define (intersection-set2 l1 l2)
  (tree->list (tree-intersection-set (list->tree l1) (list->tree l2))))

(intersection-set2 '(1 2 3) '())
(intersection-set2 '() '(1 2 3))

(intersection-set2 '(1 3) '(2 4))
(intersection-set2 '(1 3 5) '(2 4))
(intersection-set2 '(2 4) '(1 3))
(intersection-set2 '(2 4) '(1 3 5))
(intersection-set2 '(3 4) '(1 3 5))

; うーん、なんか釈然としない…
; リストと木の変換はオーダー低いとはいえコストはあるわけで、
; 減らした方がいいんじゃないかと思う
