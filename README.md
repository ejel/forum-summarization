== Setup ==

# Add mead lib to PERL5LIB env var `export PERL5LIB=$PERL5LIB:~/mead/lib:~/mead/lib/arch`
# install Lingua::StopWords

== Usage ==

# create cluster file
gen-cluster.rb
# convert xml to docsent
docsent-post.xsl, docsent-sentence.xsl

# MEAD generates summaries to destination dir
```
for file (/Users/ejel/post-summarization/Sentences/NYC/*.docsent) ~/mead/bin/mead.pl -reranker "~/mead/bin/cst-rerankers/mmr-reranker.pl 0.3 MEAD-cosine enidf"  -summary -o ~/post-summarization/Sentences/NYC/mead-output/post-mmr-l03/$file:t:r -cluster_dir ~/post-summarization/Sentences/NYC  -docsent_dir ~/post-summarization/Sentences/NYC $file:r
```
# do this for as many classifiers as wanted
# ROUGE evaluation them all at once
# convert plain text summary to ROUGE XML
`mead2rouge.pl`

# run ROUGE
`~/ROUGE-1.5.5/ROUGE-1.5.5.pl -a -s -m -n 1 -n 2 settings.xml`