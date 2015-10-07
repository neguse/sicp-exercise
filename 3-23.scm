#lang racket
(require r5rs)

; うーん、最初はあっさりと作れるかと思ったんだけど
; O(1)で、っていう縛りがあるとrear-delete-queue!の実装がそのままだと無理で
; 双方向リストにしないとだめっぽい。


(define (make-node item) (cons item (cons '() '())))
(define (item-node node) (car node))
(define (next-node node) (cadr node))
(define (prev-node node) (cddr node))
(define (set-item-node! node item) (set-car! node item))
(define (set-next-node! node item) (set-car! (cdr node) item))
(define (set-prev-node! node item) (set-cdr! (cdr node) item))

(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))
(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
	(error "FRONT called with an empty queue" queue)
	(item-node (front-ptr queue))))
(define (rear-queue queue)
  (if (empty-queue? queue)
	(error "REAR called with an empty queue" queue)
	(item-node (rear-ptr queue))))

(define (front-insert-queue! queue item)
  (let ((new-node (make-node item)))
	(cond ((empty-queue? queue)
		   (set-front-ptr! queue new-node)
		   (set-rear-ptr! queue new-node)
		   queue)
		  (else
			(set-next-node! new-node (front-ptr queue))
			(set-prev-node! (front-ptr queue) new-node)
			(set-front-ptr! queue new-node)
			queue))))

(define (front-delete-queue! queue)
  (cond ((empty-queue? queue)
		 (error "DELETE! called with an empty queue" queue))
		((null? (next-node (front-ptr queue)))
		 (set-front-ptr! queue '())
		 (set-rear-ptr!  queue '())
		 queue)
		(else
		  (set-front-ptr! queue (next-node (front-ptr queue)))
		  (set-prev-node! (front-ptr queue) '())
		  queue))) 

(define (rear-insert-queue! queue item)
  (let ((new-node (make-node item)))
	(cond ((empty-queue? queue)
		   (set-front-ptr! queue new-node)
		   (set-rear-ptr! queue new-node)
		   queue)
		  (else
			(set-prev-node! new-node (rear-ptr queue))
			(set-next-node! (rear-ptr queue) new-node)
			(set-rear-ptr! queue new-node)
			queue))))

(define (rear-delete-queue! queue)
  (cond ((empty-queue? queue)
		 (error "DELETE! called with an empty queue" queue))
		((null? (prev-node (rear-ptr queue)))
		 (set-front-ptr! queue '())
		 (set-rear-ptr! queue '())
		 queue)
		(else
		  (set-rear-ptr! queue (prev-node (rear-ptr queue)))
		  (set-next-node! (rear-ptr queue) '())
		  queue)))

(define (print-queue queue)
  (define (print-iter node)
	(cond
	  ((null? node) '())
	  (else
		(display (item-node node))
		(print-iter (next-node node)))))
  (print-iter (front-ptr queue)))


(define q (make-queue))

(front-insert-queue! q 'a)
(print-queue q)
(front-insert-queue! q 'b)
(print-queue q)
(front-insert-queue! q 'c)
(print-queue q)
(front-delete-queue! q)
(print-queue q)
(front-delete-queue! q)
(print-queue q)
(front-delete-queue! q)
(print-queue q)

(rear-insert-queue! q 'a)
(print-queue q)
(rear-insert-queue! q 'b)
(print-queue q)
(rear-insert-queue! q 'c)
(print-queue q)
(rear-delete-queue! q)
(print-queue q)
(rear-delete-queue! q)
(print-queue q)
(rear-delete-queue! q)
(print-queue q)

; よし。

