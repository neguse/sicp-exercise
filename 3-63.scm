#lang racket

(require racket/stream)
; これrequireすると、関数の名前は違うけど遅延streamの実装が使えるらしい
; http://docs.racket-lang.org/reference/streams.html

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))


; これが元の定義
;(define (sqrt-stream x)
;  (define guesses
;	(cons-stream 1.0
;				 (stream-map (lambda (guess)
;							   (sqrt-improve guess x))
;							 guesses)))
;  guesses)

; これがLouis Reasonerさんの定義
(define (sqrt-stream x)
  (cons-stream 1.0
			   (stream-map (lambda (guess)
							 (sqrt-improve guess x))
						   (sqrt-stream x))))

; Louisさんの定義だと、1ステップごとにexponentialに伸びるとのことだったのだけど
; いまいち理解できない…
; cons-streamのcdr部って、どのタイミングで評価されるんだっけ?
; cdr-streamを呼んだタイミングだった気がするのだけど、そうすると確かに
; sqrt-improveがステップごとに1回、2回、4回、8回…と呼び出し回数が増えそうな気がする。
; で、これはmemoizationしとけば大丈夫なやつですね。
; なるほど～

