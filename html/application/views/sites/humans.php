
<div class="content">
	<div class="page-header">
		<h1>Latest Websites <small> with humans.txt</small></h1>
	</div>
	<div class="row">
		<div class="span12">
			<p>The following domains have all been indexed by <em>Humans Who Made</em> and found to have humans.txt
		files, take a look through to see who was behind the creation of each site.</p>
			
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
			
      <?php echo $this->pagination->create_links(); ?>
		</div>
	</div>
</div>
