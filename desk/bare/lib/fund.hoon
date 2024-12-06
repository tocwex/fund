/-  *fund
|%
++  proj-meta
  |=  [lag=flag pro=proj:proj]
  ^-  meta:meta
  :*  title=title.pro
      image=image.pro
      cost=(roll (turn milestones.pro |=(m=mile:proj cost.m)) add)
      payment=payment.pro
      launch=p:xact:(fall contract.pro *oath)
      worker=p.lag
      oracle=p.assessment.pro
  ==
++  prej-mete
  |=  [lag=flag pre=prej:proj]
  ^-  mete:meta
  [(proj-meta lag -.pre) live.pre]
--
