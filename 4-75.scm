
(unique (job ?x (computer wizard)))

(unique (job ?x (computer programmer)))

(and (job ?x ?j) (unique (job ?anyone ?j)))

; 処理系の実装がよくわかっていない状態だと全然解けなかったけど
; ちゃんと理解したらわりとあっさり解けた。
; すごい。
