
<div class="content">
	<div class="page-header">
		<h1><?php echo $human->name; ?> <small> the humans.txt</small></h1>
	</div>
	<div class="row">
		<div class="span12">
			<pre>
			<?php echo htmlentities($human->txt); ?>
			</pre>
			<p>Visit the <a href="http://<?php echo $human->name; ?>"><?php echo $human->name; ?></a> website.</p>
		</div>
		<div class="span2">
			<h2>Tags</h2>
			<?php foreach ($tags as $tag) { ?>
	<a href="/tag/<?php echo urlencode($tag->name); ?>" class="tag"><?php echo $tag->name; ?></a>
	<?php } ?>
		</div>
	</div>
</div>
