#lang racket
; f(a,b) = 2^a * 3^b とすると、
; a = 0, b = 0 のとき… 2^0 * 3^0 = 1
; a = 1, b = 0 のとき… 2^1 * 3^0 = 2
; a = 2, b = 0 のとき… 2^2 * 3^0 = 4
; a = 0, b = 1 のとき… 2^0 * 3^1 = 3
; a = 1, b = 1 のとき… 2^1 * 3^1 = 6
; a = 2, b = 1 のとき… 2^2 * 3^1 = 12
; ...
; 2と3は素数なので、f(a,b) = 2^a * 3^bの時
; f()の値が決まると、aとbの値はf()を素因数分解することにより
; 一意に定まる。
; ここで、aとbの対を、f(a,b) = 2^a * 3^bの値で表すとしてみる。
; そうすると、
; carはf()の値を2で因数分解したもの、
; cdrはf()の値を3で素因数分解したもの、
; consはf()を計算することで達成できそうである。

; 今回もまたcarの再定義ができないっぽいので、適当に名前を崩してます
; factorize, defactorizeという関数を使えば楽できるっぽいので使う

(require math/number-theory)

(define (lookup-list l n)
  (cond
	((null? l) 0)
	((= (car (car l)) n) (car (cdr (car l))))
	(else (lookup-list (cdr l) n))))

(define (conz x y)
  (defactorize (list (list 2 x) (list 3 y))))

(define (caa z)
  (lookup-list (factorize z) 2))

(define (cda z)
  (lookup-list (factorize z) 3))

(= (conz 0 0) 1)
(= (caa (conz 0 0)) 0)
(= (cda (conz 0 0)) 0)
(= (conz 1 0) 2)
(= (caa (conz 1 0)) 1)
(= (cda (conz 1 0)) 0)
(= (conz 2 0) 4)
(= (caa (conz 2 0)) 2)
(= (cda (conz 2 0)) 0)
(= (conz 0 1) 3)
(= (caa (conz 0 1)) 0)
(= (cda (conz 0 1)) 1)
(= (conz 1 1) 6)
(= (caa (conz 1 1)) 1)
(= (cda (conz 1 1)) 1)
(= (conz 2 1) 12)
(= (caa (conz 2 1)) 2)
(= (cda (conz 2 1)) 1)
; よし。
