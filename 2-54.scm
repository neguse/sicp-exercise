#lang racket

(define (equal? a b)
  (or
	(eq? a b)
	(and
	  (pair? a)
	  (pair? b)
	  (equal? (car a) (car b))
	  (equal? (cdr a) (cdr b)))))

(equal? '(this is a list) '(this is a list))

(equal? '(this is a list) '(this (is a) list))

; こんなもんでいいのかな
; http://www.billthelizard.com/2012/03/sicp-253-255-symbolic-data.html
(equal? '() '())
(equal? '() 'a)
(equal? '((x1 x2) (y1 y2)) '((x1 x2) (y1 y2)))
(equal? '((x1 x2) (y1 y2)) '((x1 x2 x3) (y1 y2)))
(equal? '(x1 x2) 'y1)
(equal? 'abc 'abc)
(equal? 123 123)
; あってるっぽい
