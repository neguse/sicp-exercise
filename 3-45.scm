
; withdrawとかを呼び出した時と、serialized-exchangeとか経由で呼び出した時とで
; 多重にロックしてしまうので、mutex実装にもよるんだろうけど、デッドロックになる気がする…

