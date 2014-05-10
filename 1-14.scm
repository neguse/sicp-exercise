#lang racket

; 呼び出し履歴をprintするようにして、「木構造にしました」ってことにしよう。
; 手でかくのめんどくさすぎる。

(define (indent level)
	(if (< 0 level)
		(begin
			(printf " ")
			(indent (- level 1)))
		#f))

(define (count-change level amount)
	(indent level)
	(printf "count-change ~s~n" amount)
	(cc (+ level 1) amount 5))

(define (cc level amount kinds-of-coins)
	(indent level)
	(printf "cc ~s ~s~n" amount kinds-of-coins)
	(cond ((= amount 0) 1)
				((or (< amount 0) (= kinds-of-coins 0)) 0)
				(else (+ (cc (+ level 1) amount
										 (- kinds-of-coins 1))
								 (cc (+ level 1) (- amount
												(first-denomination (+ level 1) kinds-of-coins))
										 kinds-of-coins)))))

(define (first-denomination level kinds-of-coins)
	(indent level)
	(printf "first-denomination ~s ~n" kinds-of-coins)
	(cond ((= kinds-of-coins 1) 1)
				((= kinds-of-coins 2) 5)
				((= kinds-of-coins 3) 10)
				((= kinds-of-coins 4) 25)
				((= kinds-of-coins 5) 50)))

; 表示してみた。
; --------
; count-change 11
;  cc 11 5
;   cc 11 4
;    cc 11 3
;     cc 11 2
;      cc 11 1
;       cc 11 0
;       first-denomination 1 
;       cc 10 1
;        cc 10 0
;        first-denomination 1 
;        cc 9 1
;         cc 9 0
;         first-denomination 1 
;         cc 8 1
;          cc 8 0
;          first-denomination 1 
;          cc 7 1
;           cc 7 0
;           first-denomination 1 
;           cc 6 1
;            cc 6 0
;            first-denomination 1 
;            cc 5 1
;             cc 5 0
;             first-denomination 1 
;             cc 4 1
;              cc 4 0
;              first-denomination 1 
;              cc 3 1
;               cc 3 0
;               first-denomination 1 
;               cc 2 1
;                cc 2 0
;                first-denomination 1 
;                cc 1 1
;                 cc 1 0
;                 first-denomination 1 
;                 cc 0 1
;      first-denomination 2 
;      cc 6 2
;       cc 6 1
;        cc 6 0
;        first-denomination 1 
;        cc 5 1
;         cc 5 0
;         first-denomination 1 
;         cc 4 1
;          cc 4 0
;          first-denomination 1 
;          cc 3 1
;           cc 3 0
;           first-denomination 1 
;           cc 2 1
;            cc 2 0
;            first-denomination 1 
;            cc 1 1
;             cc 1 0
;             first-denomination 1 
;             cc 0 1
;       first-denomination 2 
;       cc 1 2
;        cc 1 1
;         cc 1 0
;         first-denomination 1 
;         cc 0 1
;        first-denomination 2 
;        cc -4 2
;     first-denomination 3 
;     cc 1 3
;      cc 1 2
;       cc 1 1
;        cc 1 0
;        first-denomination 1 
;        cc 0 1
;       first-denomination 2 
;       cc -4 2
;      first-denomination 3 
;      cc -9 3
;    first-denomination 4 
;    cc -14 4
;   first-denomination 5 
;   cc -39 5
; --------
;
; …で、これのスペースとステップ数の増加の程度を調べなきゃなんだけど、どうすれバインダー
;
; nはcount-changeの引数amountとして、
;
; スペースはコールスタックの深さと同じなのだけど、
; 1ずつ減っていった時が最深になるので、nとだいたい同じになるんじゃないだろうか。
; ということで、たぶんスペースはθ(n)
;
; ステップ数は、たぶんcount-change(n)の値とほぼ同じだと思うんだけど、
; …よくわからん。のでカンニングしたところ、θ(n^5) らしい。
;
; cc(n, 1)がθ(n)で、
; cc(n, 2) = cc(n, 1) + cc(n-5, 2) = cc(n, 1) + cc(n-5, 1) + cc(n-10, 2) = ...
; というふうにθ(n)が5ずつ減っていく場合の和になるので、おおざっぱにθ(n^2)となる。
; ような、硬貨の種類乗になると。わかったようなわからんような…

