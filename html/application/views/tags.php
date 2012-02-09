
<div class="content">
	<div class="page-header">
		<h1>Tags <small> for which we found humans.txt</small></h1>
	</div>
	<div class="row">
		<div class="span12">
			<p><em>Humans Who Made</em> indexes sites with humans.txt using tags found in links to those
		sites as well as tags extracted from the files themselves. We recommend you follow the humans.txt
		standard guidelines to ensure you domain is tagged accurately.</p>
			
			<div class="threecolumns">
			<?php foreach ($tags as $tag) { ?>
	<a href="/tag/<?php echo urlencode($tag->name); ?>" class="tag label" style="font-size: <?php echo 8+round($tag->uses * ($max_uses/50)); ?>px"><?php echo $tag->name; ?></a>
	<?php } ?>
			</div>
			
		</div>
	</div>
</div>