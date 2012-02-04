<div class="content">
	<div class="page-header">
		<h1><?php echo str_replace('www.', '', $human->name); ?> <small> the humans.txt</small></h1>
	</div>
	<div class="row">
		<div class="span12">
			<?php if ((!is_null($human->title)) and ($human->title != '')) { ?>
			<h2><?php echo $human->title; ?></h2>
			<?php } ?>
			<?php if ((!is_null($human->description)) and ($human->description != '')) { ?>
			<p><?php echo $human->description; ?></p>
			<?php } ?>
<pre>
test
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
