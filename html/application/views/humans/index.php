<div class="content">
	<div class="page-header">
		<h1><?php echo str_replace('www.', '', $human->name); ?> <small> the humans.txt</small></h1>
	</div>
	<div class="row">
		<div class="span9">
			<?php if ((!is_null($human->title)) and ($human->title != '')) { ?>
			<h2><?php echo $human->title; ?></h2>
			<?php } ?>
			<?php if ((!is_null($human->description)) and ($human->description != '')) { ?>
			<p><?php echo $human->description; ?></p>
			<?php } ?>
<pre>
<?php echo $human->txt; ?>
</pre>
			<p>Visit the <a href="http://<?php echo $human->name; ?>"><?php echo $human->name; ?></a> website.</p>
		</div>
		<div class="span3">
			<h2>Tags</h2>
			<?php foreach ($tags as $tag) { ?>
	<a href="/tag/<?php echo urlencode($tag->name); ?>" class="tag label label-info"><?php echo $tag->name; ?></a>
	<?php } ?>
		</div>
	</div>
	
	<div class="row">
		<div class="span12">

<div id="disqus_thread"></div>
<script type="text/javascript">
    var disqus_shortname = 'humanswhomade';
	 (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = 'http://' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">blog comments powered by <span class="logo-disqus">Disqus</span></a>

			
		</div>
	</div>
	
</div>
