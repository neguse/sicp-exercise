#lang racket
(require r5rs)

(define (assoc-f cmp key records)
  (cond ((null? records) false)
        ((cmp key (caar records)) (car records))
        (else (assoc-f cmp key (cdr records)))))

(define (make-table cmp)
  (let ((local-table (list '*table*)))
	(define (lookup key-1 key-2)
	  (let ((subtable (assoc-f cmp key-1 (cdr local-table))))
		(if subtable
		  (let ((record (assoc-f cmp key-2 (cdr subtable))))
			(if record
			  (cdr record)
			  false))
		  false)))
	(define (insert! key-1 key-2 value)
	  (let ((subtable (assoc-f cmp key-1 (cdr local-table))))
		(if subtable
		  (let ((record (assoc-f cmp key-2 (cdr subtable))))
			(if record
			  (set-cdr! record value)
			  (set-cdr! subtable
						(cons (cons key-2 value)
							  (cdr subtable)))))
		  (set-cdr! local-table
					(cons (list key-1
								(cons key-2 value))
						  (cdr local-table)))))
	  'ok)    
	(define (dispatch m)
	  (cond ((eq? m 'lookup-proc) lookup)
			((eq? m 'insert-proc!) insert!)
			(else (error "Unknown operation -- TABLE" m))))
	dispatch))

(define (equal-mod3? x y)
	(let ((xm (modulo x 3))
		  (ym (modulo y 3)))
	  (equal? xm ym)))

(define operation-table (make-table equal-mod3?))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(put 1 1 1)
(put 2 2 2)
(get 1 1)
; -> 1
(get 4 7)
; -> 1

; よし。


