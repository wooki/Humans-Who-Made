<div class="hero-unit">
	<h1>Humans who built the web</h1>
	<p><em>Humans Who Made</em> is an index of websites and information about
	who built them - use this as part of your portfolio, or just if you are
	curious.</p>
	<p><a href="/about-us" class="btn btn-primary btn-large">Learn more &raquo;</a>
		
	<div style="top: -20px; margin-right: 80px; float: right;"><div class="fb-like" data-href="http://humanswhomade.com" data-send="false" data-layout="button_count" data-show-faces="false"></div></div>
	<div style="top: -20px; float: right;"><g:plusone size="medium"></g:plusone></div>
	<div style="top: -20px; float: right;"><a href="https://twitter.com/share" class="twitter-share-button" data-via="HumansWhoMade">Tweet</a></div>
	</p>

	</p>
</div>

<!-- Example row of columns -->
<div class="row">
	<div class="span4">
		<h2>How it works</h2>
		 <p><em>Humans Who Made</em> crawls the web looking for
	websites that implement the humans.txt standard to determine who was behind
	each site. This has the advantage of ensuring that the people listed on this
	site really do have access to the site they are claiming to	have developed
	and also it allows us to list a huge number of websites and people easily.</p>
	<p><a class="btn" href="/about-us">About Humans Who Made &raquo;</a></p>
 </div>
	<div class="span4">
		<h2>About humans.txt</h2>
		<p>The idea behind humans.txt is to create a way of knowing who developed,
		created or authored a website. You simply place the information
		in a simpe text file in the root of your site.</p>
		<p><a class="btn" href="/humans-txt">About humans.txt &raquo;</a></p>
<p class="center"><img src='/img/Dino_blue_128x128.png' alt="Learn more about humans.txt files" height="128" width="128" /></p>
	</div>
	<div class="span4">
		<h2>Tags</h2>
		<p>
			<?php foreach ($tags as $tag) { ?>
	<a href="/tag/<?php echo urlencode($tag->name); ?>" class="tag label label-info" style="font-size: <?php echo 8+round($tag->uses * ($max_uses/50)); ?>px"><?php echo $tag->name; ?></a>
	<?php } ?></p>
			<p><a class="btn" href="/tags">More Tags &raquo;</a></p>
	</div>
</div>

