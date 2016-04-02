#lang racket

; a.について
; 今の仕組みだと、list-of-delayed-args呼び出しでthunkができるんだけど
; それはどこかというと、compound-procedureの場合のapplyにおけるoperandsだけ。
; この例だとそもそもthunkが作られる箇所がないのでどっちでも一緒なんじゃないか。
; というか、Cyさんのとおりに変えても変えなくても挙動かわんないですよね。

; b.について
; 元々のだと、(p1 1) => (1 2), (p2 1) => 1 だった。
; Cyさんのだと、エラーになった。
; 他の人の見てると通ってるけど結果が違うという感じっぽいので
; なんだかなあという感じ。

; c.について
; a. のとおり

; d.について
; あまりわかってないですけど、Haskellのdoみたいにすべきじゃないですか。
; なんにせよ、デフォルトな遅延評価と参照透過じゃない評価の組み合わせの処理系って
; ちゃんと使うの厳しいと思う。
