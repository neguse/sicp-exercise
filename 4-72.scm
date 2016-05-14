
; わけがわからなくなってきたので、ソースをちゃんと読んでいく。

; stream-flatmapの型がわからなかった。
; procはstream<T> -> stream<stream<T>>
; sはstream<T>ということっぽい。
; stream-flatmapはinterleave-delayedを使って混ぜていく。

; で、なぜstream-flatmapやdisjoinがinterleave-delayedを使っているかだけど、
; やっぱりよくわからんよなあ。
; 無限ループだと止まらなくなるというのは確かにそうだけど、
; どういう状態だと無限ループになる?

; https://github.com/ypeels/sicp/blob/master/exercises/4.72-interleave-in-disjoin-and-flatmap.scm
; うーん、最後の例interleave-delayedつかう実装でも
; 最初の答えが出るまえに無限ループになるんだよなあ…

