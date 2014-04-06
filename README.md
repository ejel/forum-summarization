## Setup ##

1. Add MEAD lib to PERL5LIB env var `export PERL5LIB=$PERL5LIB:~/mead/lib:~/mead/lib/arch`
2. Requires Lingua::StopWords

## Usage ##

* create cluster files
`gen-cluster.rb`
* convert xml to docsent
`docsent-post.xsl`, `docsent-sentence.xsl`

* MEAD generates summaries to destination dir:
```
for file (Sentences/NYC/*.docsent) ~/mead/bin/mead.pl -reranker "~/mead/bin/cst-rerankers/mmr-reranker.pl 0.3 MEAD-cosine enidf"  -summary -o Sentences/NYC/mead-output/post-mmr-l03/$file:t:r -cluster_dir Sentences/NYC  -docsent_dir Sentences/NYC $file:r
```
* Generate ROUGE input files from MEAD summaries `mead2rouge.pl`

* run ROUGE
`~/ROUGE-1.5.5/ROUGE-1.5.5.pl -a -s -m -n 1 -n 2 settings.xml`