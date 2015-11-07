#lang racket

; うーん、マクロの定義の仕方説明してないので試せない…
; SICPの練習問題、本文以外のところを勉強しないと解けないことが多くて
; ちょっとあれだなぁ。
; なんとなく想像でやりますか。

(define (show x)
  (display-line x)
  x)

(define x (stream-map show (stream-enumerate-interval 0 10)))
; streamを作るだけでforceしてないから、何も出力されない

(stream-ref x 5)
; 0～5が出力される

(stream-ref x 7)
; メモ化が実装されてれば、6,7が出力される
; メモ化が実装されてなければ、0～7が出力される

; でどうでしょうか。
; http://d.hatena.ne.jp/mtsuyugu/20080610/1213107208
; > (cons-stream a b) だと a は即座に評価される。
; > ということは stream-enumerate-interval と stream-map も一番最初の要素は即座に評価される。
; なるほど。

