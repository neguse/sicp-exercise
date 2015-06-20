#lang racket

; なんかもう、動かさなくてもいいかなという気になってきた。
; なんとなくで実装できればそれでいいことにする。

; まずsuperを片方にどんどん適用していって、同じ型になったらOK、最後までやってだめだったらNGとする
; だめだったらもう片方もやってみる、という感じ。

(define (try-coercion type-to value)
  (let ((super (raise value)))
	(cond
	  ((not super)
	   #f)
	  ((eq? (type-tag super) type-to)
	   super)
	  (else
		(try-coercion type-to super)))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
	(let ((proc (get op type-tags)))
	  (if proc
		(apply proc (map contents args))
		(if (= (length args) 2)
		  (let ((type1 (car type-tags))
				(type2 (cadr type-tags))
				(a1 (car args))
				(a2 (cadr args)))
			(let ((a1-to-t2 (try-coercion type2 a1))
				  (a2-to-t1 (try-coercion type1 a2)))
			  (cond (a1-to-t2
					  (apply-generic op a1-to-t2 a2))
					(a2-to-t1
					  (apply-generic op a1 a2-to-t1))
					(else
					  (error "No method for these types"
							 (list op type-tags))))))
		  (error "No method for these types"
				 (list op type-tags)))))))


