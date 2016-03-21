#lang racket

; http://community.schemewiki.org/?sicp-ex-4.18

; まず、この問題どおりに2重のletに変換した場合
; dyの評価にはyの値が必要なのだけど、この方法だとこの時点で*undefined*なので
; だめっぽいということらしい。

; 本文の方法だと、
; dyを評価する際にはyがset!されたあとなので大丈夫ということらしい。
