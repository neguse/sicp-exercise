
(assert! (son Adam Cain))
(assert! (son Cain Enoch))
(assert! (son Enoch Irad))
(assert! (son Irad Mehujael))
(assert! (son Mehujael Methushael))
(assert! (son Methushael Lamech))
(assert! (wife Lamech Ada))
(assert! (son Ada Jabal))
(assert! (son Ada Jubal))

(assert! (rule (son ?s ?m)
			   (and
				 (wife ?w ?m)
				 (son ?s ?w))))

(assert! (rule (grandson ?s ?g)
			   (and
				 (son ?s ?f)
				 (son ?f ?g))))

(grandson ?x ?y)
(son ?x ?y)

