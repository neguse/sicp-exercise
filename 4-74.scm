

(define (simple-stream-flatmap proc s)
  (simple-flatten (stream-map proc s)))

(define (simple-flatten stream)
  (stream-map stream-append
			  (stream-filter (lambda (s) (not (stream-null? s))) stream)))

; こんな感じかなあ。
; 別にかわんないと思うんだけど…
; …stream-appendじゃなくてstream-carでした。
; stream-appendはarityが2なので使えないですね。
; > 常に空ストリームか単一ストリームを生じ
; から、carでもいい、という感じでしょうか。

