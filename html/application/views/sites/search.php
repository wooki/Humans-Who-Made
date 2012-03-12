
<div class="content">
	<div class="page-header">
		<h1><?php echo $term; ?> Humans.txt <small>search results</small></h1>
	</div>
	<div class="row">
		<div class="span12">
			<p>The sites below were found to match your search term, to link to this
			page you can use this url: <a href="<?php echo site_url(array('sites', 'search', $term)); ?>"><?php echo $term; ?></a></p>
			
			<?php foreach ($domains as $human) { ?>
			
<div class="row">
		<div class="span12">
			<?php if ((!is_null($human->title)) and ($human->title != '')) { ?>
			<h2><?php echo $human->title; ?></h2>
			<?php } else { ?>
                        <h2><?php echo $human->name; ?></h2>
                        <?php } ?>

			<?php if ((!is_null($human->description)) and ($human->description != '')) { ?>
			<p><?php echo $human->description; ?></p>
			<?php } ?>
<pre>
<?php echo substr($human->txt, 0, 500); ?>
</pre>
			<p>Read more on <a href="<?php echo site_url(array('humans', $human->name)); ?>">
<?php if ((!is_null($human->title)) and ($human->title != '')) { ?>
<?php echo $human->title; ?>
<?php } else { ?>
<?php echo $human->name; ?>
<?php } ?></a>.</p>
		</div>
	</div>      
      
			<?php } ?>
			
		</div>
	</div>
</div>
