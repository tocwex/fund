::  /ted/nfz-okay.hoon: checks if the metadata attributes for a list of
::  NFTs satisfies a given set of predicates
::
::    -fund!nfz-okay ~[[0 "https://erc721-uri.com/id.json"]] ~ ~
::
::    -fund!nfz-okay ~[[0 "https://azimuth.network/erc721/0.json"] [256 "https://azimuth.network/erc721/256.json"]] (malt ~[[%size |=(=@t =(%star t))]]) ~
::
/-  spider, fund-watcher
/+  io=strandio, fx=fund-xtra
=,  strand=strand:spider
^-  thread:spider
|=  arg=vase
=/  m  (strand ,vase)
^-  form:m
=+  !<([~ nfz=(list [nid=@ url=tape]) fil=(map @t $-(@t ?)) try=(unit @ud)] arg)
=/  cfg=outbound-config:iris  [redirects=5 retries=(fall try 3)]
;<    joz=(list json)
    bind:m
  =/  m  (strand ,(list json))
  =|  cur=(list json)
  |-  ^-  form:m
  ?~  nfz  (pure:m (flop cur))
  =/  url=@t  (crip url.i.nfz)
  ;<  ~  bind:m  (send-raw-card:io %pass /request %arvo %i %request [%'GET' url ~ ~] cfg)
  ;<  res=client-response:iris  bind:m  take-client-response:io
  =/  bod=@t  ?>(?=(%finished -.res) ?~(full-file.res '' q.data.u.full-file.res))
  =/  jon=(unit json)  (de:json:html bod)
  ::  TODO: If any of the given endpoints has invalid JSON, throw error
  ::  for the whole thread; should this be more forgiving?
  ?~  jon  (strand-fail:strand %json-parse-error ~)
  $(nfz t.nfz, cur [u.jon cur])
=-  (pure:m !>(gud))
^-  gud=(set @)
%+  roll  (izip:fx nfz joz)
::  TODO: NFTs with ill-formatted JSON are just ignored; should they
::  cause thread errors instead?
|=  [[[nid=@ url=tape] jon=json] acc=(set @)]
?.  ?=(%o -.jon)  acc
?~  aon=(~(get by p.jon) 'attributes')  acc
?.  ?=(%a -.u.aon)  acc
=-  ?.(gud acc (~(put in acc) nid))
^-  gud=?
=-  (~(rep by fil) |=([[k=@t v=$-(@t ?)] a=?] &(a ?~(t=(~(get by nat) k) | (v u.t)))))
^-  nat=(map @t @t)
%-  malt
%+  murn  p.u.aon
|=  eon=json
^-  (unit [@t @t])
?.  ?=(%o -.eon)  ~
?~  ton=(~(get by p.eon) 'trait_type')  ~
?.  ?=(%s -.u.ton)  ~
?~  von=(~(get by p.eon) 'value')  ~
?.  ?=(%s -.u.von)  ~
`[p.u.ton p.u.von]
