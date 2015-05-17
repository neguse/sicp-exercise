#lang racket

; office - records > record > address, salary

(define global-table '())

(define (put op type item)
  (set! global-table
	(cons (list op type item) global-table)))

(define (get op type)
  (define (get-inner op type table)
	(if (and
		  (eq? (caar table) op)
		  (eq? (cadar table) type))
	  (caddar table)
	  (get-inner op type (cdr table))))
  (get-inner op type global-table))

; 事業所ごとにインタフェースを用意すればよいのかな

(define (office-tag office)
  (car office))
(define (office-records office)
  (cadr office))
(define (record-tag record)
  (car record))
(define (record-record record)
  (cadr record))

(define (get-record name office)
  ((get 'get-record (office-tag office)) name (office-records office)))
(define (get-salary record)
  ((get 'get-salary (record-tag record)) (record-record record)))

(define (find-employee-record name offices)
  (let
	((record (get-record name (car offices))))
	(if (null? record)
	  (find-employee-record name (cdr offices))
	  record)))

(define (install-kanto-package)
  (define (get-record-kanto name records)
	(cond
	  ((null? records) '())
	  ((eq? (caar records) name)
	   (list 'kanto (car records)))
	  (else
		(get-record-kanto name (cdr records)))))
  (put 'get-record 'kanto get-record-kanto)
  (define (get-salary-kanto record)
	(caddr record))
  (put 'get-salary 'kanto get-salary-kanto)
  'done)
(install-kanto-package)

(define kanto-office
  '(kanto
	 (
	  ("Charmander" "Professor Oak" 1059860)
	  ("Mewtwo" "Cerulean Cave" 1250000)
	  )))

(define johto-office
  '(kanto
	 (
	  ("Raikou" "Random" 1250000)
	  )))

(get-salary (get-record "Charmander" kanto-office))
(find-employee-record "Raikou" (list kanto-office johto-office))

; とりあえずこんなもんかなぁ。
; office, recordそれぞれから型をたどれる必要があると思うんだけど、
; それを満たすには制約がきつそうなので、
; なんか微妙だなーとおもいました。

; d. この企業が, 別の会社を合併した時, 新しい従業員情報を中央システムに組み込むには, どういう変更をすべきか. 
; 会社 > 事業所 > 従業員 というふうに階層を一個増やすだけでいいんじゃないか。
; いろいろ面倒だと思うので、このシステム捨ててデータ構造あわせた方がいいと思うけど…

