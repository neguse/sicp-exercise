#lang racket
(require r5rs)

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))
(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))
(define (front-queue queue)
  (if (empty-queue? queue)
	(error "FRONT called with an empty queue" queue)
	(car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
	(cond ((empty-queue? queue)
		   (set-front-ptr! queue new-pair)
		   (set-rear-ptr! queue new-pair)
		   queue)
		  (else
			(set-cdr! (rear-ptr queue) new-pair)
			(set-rear-ptr! queue new-pair)
			queue)))) 

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
		 (error "DELETE! called with an empty queue" queue))
		(else
		  (set-front-ptr! queue (cdr (front-ptr queue)))
		  queue))) 

; この実装だとキューのデータ構造は単なるリストとしてでなく
; リストと、front-ptr - rear-ptrの対の2つからなるので、
; これを単純にprintすると処理系がrear-ptrの分を2回表示してしまう。

; これをちゃんと表示するにはfrontから表示すればよい。

(define (print-queue queue)
  (display (front-ptr queue)))

