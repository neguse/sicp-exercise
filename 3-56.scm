#lang racket

; mergeだけだと2つのストリームしかマージできないので
; mergeを複数ストリームでやる関数用意して
(define (merge* s1 . s2)
  (if (null? s2)
	s1
	(merge s1 (apply merge* s2))))

; こうじゃ
(define S
  (cons-stream 1 (merge*
				   (scale-stream S 2)
				   (scale-stream S 3)
				   (scale-stream S 5))))

; と思いました。
