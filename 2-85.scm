#lang racket

; dropはこんな感じで。

(define (project x) (apply-generic 'project x))

(put 'project '(complex)
	 (lambda (x) (make-real (car x))))

(define (drop x)
  (let ((p (project x)))
	(if (equ? (raise p) x)
	  x
	  #f)))

; apply-genericは…別に変わんない気がするんだよなぁ。

