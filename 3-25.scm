#lang racket
(require r5rs)

(define (assoc-f cmp key records)
  (cond ((null? records) false)
        ((cmp key (caar records)) (car records))
        (else (assoc-f cmp key (cdr records)))))

(define (make-table cmp)
  (let ((local-table (list '*table*)))
	(define (lookup keys)
	  (define (lookup-iter keys table)
		(if (null? keys) (cdr table)
		  (let
			((subtable (assoc-f cmp (car keys) (cdr table))))
			(if subtable
			  (lookup-iter (cdr keys) subtable)
			  false))))
	  (lookup-iter keys local-table))
	(define (insert! keys value)
	  (define (insert-iter! keys value table)
		(if (null? keys)
		  (set-cdr! table value)
		  (let*
			((key (car keys))
			 (subtable (assoc-f cmp key (cdr table))))
			(cond
			  (subtable
				(insert-iter! (cdr keys) value subtable))
			  (else
				(set-cdr! table (cons (cons key '()) (cdr table)))
				(insert-iter! (cdr keys) value (cadr table)))))))
	  (insert-iter! keys value local-table)
	  'ok)
	(define (dispatch m)
	  (cond ((eq? m 'lookup-proc) lookup)
			((eq? m 'insert-proc!) insert!)
			(else (error "Unknown operation -- TABLE" m))))
	dispatch))

(define operation-table (make-table equal?))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(get '(a))
; -> #f
(put '(a) 1)
; -> 'ok
(get '(a))
; -> 1
(put '(b b) 2)
; -> 'ok
(get '(b b))
; -> 2
(get '(a))
; -> 1

; とりあえずこれでOKっぽいけど、
; このあと(put '(a b) 3) ってやるとエラーになるんだよね
; 今の構造だとどうしようもないし、Pythonとかでもそのはずだから
; どうしようもないとは思うけど…

