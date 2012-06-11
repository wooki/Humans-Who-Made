
<div class="content">
	<div class="page-header">
		<h1><?php echo $tagname; ?> <small> and matching websites</small></h1>
	</div>
	<div class="row">
		<div class="span12">
			<p>The following domains have all been indexed by <em>Humans Who Made</em> and found to have humans.txt
		files, take a look through to see who was behind the creation of each site.</p>
			
			<div class="twocolumns">
			<?php foreach ($domains as $domain) { ?>
			<p><a href="/humans/<?php echo urlencode($domain->name); ?>" class="domain"><?php echo $domain->name; ?></a>:
			<?php echo $domain->description ;?>
			</p>
			<?php } ?>
			</div>
			
		</div>
	</div>
</div>
