#lang racket

(define (stream-map proc . argstreams)
  (if (null? (car argstreams))
	the-empty-stream
	(cons-stream
	  (apply proc (map stream-car argstreams))
	  (apply stream-map
			 (cons proc (map stream-cdr argstreams))))))

; 動かしてないし適当だけど、こんな感じじゃないかなぁ…
; …nullかどうかのテストが、stream-null? を使う必要がありそう。

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
	the-empty-stream
	(cons-stream
	  (apply proc (map stream-car argstreams))
	  (apply stream-map
			 (cons proc (map stream-cdr argstreams))))))

; これで。
