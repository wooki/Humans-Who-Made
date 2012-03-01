<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <title><?= $title ?></title>
    <meta name="description" content="<?= $description ?>">
    <meta name="author" content="James Rowe">

    <!-- Mobile viewport optimized: j.mp/bplateviewport -->
    <meta name="viewport" content="width=device-width,initial-scale=1">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
    
    <script language="javascript" src="http://www.google.com/jsapi"></script>

    <!-- Le styles -->
    <link href="/css/bootstrap.min.css" rel="stylesheet">
    <link href="/css/style.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
      }
    </style>

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="/favicon.ico">
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/apple-touch-icon-114x114.png">

    <script type="text/javascript">
    
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-29642156-1']);
      _gaq.push(['_trackPageview']);
    
      (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
      })();
    
    </script>

    <script type="text/javascript">
      window.___gcfg = {lang: 'en-GB'};
    
      (function() {
        var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
        po.src = 'https://apis.google.com/js/plusone.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
      })();
    </script>


  </head>

  <body>
    
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner  ">
        <div class="container">
          <a class="brand" href="/">Humans Who Made</a>
          <div class="nav-collapse">
            <ul class="nav">
              <li<?php if ($active == 'home') { echo ' class="active"'; } ?>><a href="/">Home</a></li>
              <li<?php if ($active == 'about-us') { echo ' class="active"'; } ?>><a href="/about-us">About</a></li>
              <li<?php if ($active == 'humans-txt') { echo ' class="active"'; } ?>><a href="/humans-txt">humans.txt</a></li>
              <li<?php if ($active == 'tags') { echo ' class="active"'; } ?>><a href="/tags">Tags</a></li>
              <li<?php if ($active == 'sites') { echo ' class="active"'; } ?>><a href="/sites">Websites</a></li>
            </ul>
            <ul class="nav pull-right">
              <li><a href="/humans.txt"><img src="/img/humanstxt.png" alt="Humans  " /></a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="container">
