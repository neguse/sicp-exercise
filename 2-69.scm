#lang racket

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))


(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
		right
		(append (symbols left) (symbols right))
		(+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
	(list (symbol-leaf tree))
	(caddr tree)))

(define (weight tree)
  (if (leaf? tree)
	(weight-leaf tree)
	(cadddr tree)))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
	(if (null? bits)
	  '()
	  (let ((next-branch
			  (choose-branch (car bits) current-branch)))
		(if (leaf? next-branch)
		  (cons (symbol-leaf next-branch)
				(decode-1 (cdr bits) tree))
		  (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
		((= bit 1) (right-branch branch))
		(else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
		((< (weight x) (weight (car set))) (cons x set))
		(else (cons (car set)
					(adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
	'()
	(let ((pair (car pairs)))
	  (adjoin-set (make-leaf (car pair)    ; 記号
							 (cadr pair))  ; 頻度
				  (make-leaf-set (cdr pairs))))))


(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
              (encode (cdr message) tree))))

(define (include-symbol symbol tree)
  (memq symbol (symbols tree)))

(define (encode-symbol symbol tree)
  (cond
	((and (leaf? tree) (eq? symbol (symbol-leaf tree)))
	 '())
	((include-symbol symbol (left-branch tree))
	 (cons 0 (encode-symbol symbol (left-branch tree))))
	((include-symbol symbol (right-branch tree))
	 (cons 1 (encode-symbol symbol (right-branch tree))))
	(else
	  (error "bad symbol -- symbol " symbol " not found in tree" tree))))

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge branches)
  (let ((l (length branches)))
	(cond
	  ((= l 0) '())
	  ((= l 1) (car branches))
	  (else
		(successive-merge
		  (adjoin-set
			(make-code-tree (car branches) (cadr branches))
			(cddr branches)))))))

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
				  (make-code-tree
					(make-leaf 'B 2)
					(make-code-tree (make-leaf 'D 1)
									(make-leaf 'C 1)))))

(equal? 
  (generate-huffman-tree '((A 4) (B 2) (C 1) (D 1)))
  sample-tree)
; #t
; たぶんよし。
; lengthを使うと無駄にオーダーが増えるので、
; ちゃんとやるならcdrとかで頑張った方がよさそう。

