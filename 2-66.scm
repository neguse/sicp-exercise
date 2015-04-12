#lang racket

(define (key record) (car record))
(define (data record) (cdr record))
(define (make-record key data) (cons key data))

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

(define (lookup given-key set-of-records)
  (if (null? set-of-records) false
	(let
	  ((entry-key (key (entry set-of-records))))
	  (cond
		((equal? given-key entry-key)
		 (entry set-of-records))
		((< given-key entry-key)
		 (lookup given-key (left-branch set-of-records)))
		((> given-key entry-key)
		 (lookup given-key (right-branch set-of-records)))))))

(define database
  (list (make-record 1 'Bill)
        (make-record 2 'Joe)
        (make-record 3 'Frank)
        (make-record 4 'John)))
(define tree-db (list->tree database))

(lookup 1 tree-db)
(lookup 2 tree-db)
(lookup 3 tree-db)
(lookup 4 tree-db)
(lookup 5 tree-db)

; はい。
