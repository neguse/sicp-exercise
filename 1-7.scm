#lang racket

(define (square x)
  (* x x))

(define (average x y)
	(/ (+ x y) 2))

; 本文に書かれている解法

(define (good-enough-1? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt-iter-1 guess x)
	(if (good-enough-1? guess x)
		guess
		(sqrt-iter-1 (improve-1 guess x)
							 x)))

(define (improve-1 guess x)
	(average guess (/ x guess)))

(define (sqrt-1 x)
	  (sqrt-iter-1 1.0 x))

; 1.7での解法

(define (good-enough-2? guess prev-guess x)
  (< (abs (- prev-guess guess)) 0.001))

(define (sqrt-iter-2 guess prev-guess x)
	(if (good-enough-2? guess prev-guess x)
		guess
		(sqrt-iter-2 (improve-2 guess x)
							 guess
							 x)))

(define (improve-2 guess x)
	(average guess (/ x guess)))

(define (sqrt-2 x)
	  (sqrt-iter-2 1.0 0.0 x))

(define (main)
	(let ((o (read)))
		(if (eof-object? o)
			#f
			(begin
				(printf "~s,~s\n"
								(sqrt-1 o)
								(sqrt-2 o))
				(main)))))

(main)

; sqrt-1は本文に書かれている解法のもの。
; sqrt-2は1.7で書かれている解法のもの。
;
; 入力値が小さい場合、絶対値が小さいほど誤差が大きくなっている。
; これは、1.0未満の値の場合開平数よりも被開平数の方が値が大きくなってしまうため、
; 被開平数を基準として計算するsqrt-1の方法だと差分をとっても誤差が大きくなってしまうのではないか?
; …というのはあまりいい解答になっていない気がする。あまりよくわかっていない。
;
; また、sqrt-1は1e15ぐらいから停止しないようになってしまったが、
; sqrt-2は1e120とかでも問題なく結果が返った。
; 浮動小数点数の仕組み上、大きい値だとあまり精度が高くない(指数部が大きくなってしまうので、仮数部のちょっとした変化がおおきな値の変動となってしまう)のが原因じゃないかと思うが、
; これもちょっと明快な解答にはなっていないですね。うーん…

