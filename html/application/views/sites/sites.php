
<div class="content">
	<div class="page-header">
		<h1>Websites <small> with humans.txt</small></h1>
	</div>
	<div class="row">
		<div class="span12">
			<p>The following domains have all been indexed by <em>Humans Who Made</em> and found to have humans.txt
		files, take a look through to see who was behind the creation of each site.</p>
			
			<div class="threecolumns">
			<?php foreach ($domains as $domain) { ?>
			<p><a href="/humans/<?php echo urlencode($domain->name); ?>" class="domain"><?php if ((!is_null($domain->title)) and ($domain->title != '')) { echo $domain->title; } else { echo str_replace('www.', '', $domain->name); } ?></a></p>
			<?php } ?>
			</div>
			
		</div>
	</div>
</div>
