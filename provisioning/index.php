<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en" dir="ltr">
<head profile="http://gmpg.org/xfn/11">
    <title>Automated Nagios</title>
    <link rel="shortcut icon" href="/images/logo-paperinik.png">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <script type="text/javascript">
    window.addEvent('domready', function(){
    //-vertical
    var mySlide = new Fx.Slide('nagios');
    mySlide.toggle();

    $('nagios_toggle').addEvent('click', function(e){
        e = new Event(e);
        mySlide.toggle();
        e.stop();
    });

    var mySlide2 = new Fx.Slide('nagvis');
    mySlide2.toggle();

    $('nagvis_toggle').addEvent('click', function(e){
        e = new Event(e);
        mySlide2.toggle();
        e.stop();
    });

    var mySlide3 = new Fx.Slide('nagiosgraph');
    mySlide3.toggle();

    $('nagiosgraph_toggle').addEvent('click', function(e){
        e = new Event(e);
        mySlide3.toggle();
        e.stop();
    });

    var mySlide4 = new Fx.Slide('centreon');
    mySlide4.toggle();

    $('centreon_toggle').addEvent('click', function(e){
        e = new Event(e);
        mySlide4.toggle();
        e.stop();
    });

    var mySlide5 = new Fx.Slide('dokuwiki');
    mySlide5.toggle();

    $('dokuwiki_toggle').addEvent('click', function(e){
        e = new Event(e);
        mySlide5.toggle();
        e.stop();
    });
});
</script>
</head>
<body class="front not-logged-in page-node two-sidebars">
    <div id="wrapper">
        <div id="container" class="clear-block">
            <div id="header">
                <div id="logo">
                    <img src="images/logo-paperinik.png">
                </div>
                <div id="slogan-floater">
                    <h1 class="site-name">
                        <a href="">Automated Nagios</a>
                    </h1>
                </div>
            </div>
            <div id="primary-links">
                <ul class="primary-links">
                    <li class="menu-137">
                        <a href="https://github.com/brunocantisano/rpi-nagios" title="GitHub Project's">Project</a>
                    </li>
                </ul>
            </div>
            <div id="sidebar-left" class="sidebar">
                <div id="block-menu-primary-links" class="block block-menu">
                    <h2>Direct Links</h2>
                    <div class="content">
                        <ul class="menu">
                            <li class="leaf first">
                                <a href="/nagios/">Nagios (l: nagiosadmin, p:admin)</a>
                            </li>
                            <li class="leaf first">
                                <a href="/nagvis/">NagVis (l: admin, p:admin)</a>
                            </li>
                            <li class="leaf first">
                                <a href="/nagiosgraph/cgi-bin/show.cgi">Nagios Graph</a>
                            </li>
                            <li class="leaf first">
                                <a href="##CENTREON##">Centreon</a>
                            </li>
                            <li class="leaf first">
                                <a href="##DOKUWIKI##">Doku Wiki</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div id="center">
                <div id="squeeze">
                    <div id="breadcrumb"/>
                        <div class="node" <h2="">Software provided
                            <div class="content" here="" is="" the="" list="" of="" tools="" provided="" by="" fan:="" <ol="">
                                <li>
                                    <a id="nagios_toggle" href="#">Nagios: Core monitoring application</a>
                                    <div style="margin: 0px; position: static; overflow: hidden; height: 0px;">
                                        <div id="nagios" style="margin: -194px 0px 0px;">
                                            <a href="/nagios/" target="_blank">
                                                <img src="images/logo-nagios.png">
                                            </a>
                                        </div>
                                    </div>
                                </li>
                                <li>
                                    <a id="nagvis_toggle" href="#">NagVis : a great tools for configuring maps</a>
                                    <div style="margin: 0px; position: static; overflow: hidden; height: 0px;">
                                        <div id="nagvis" style="margin: -194px 0px 0px;">
                                           <a href="/nagvis/" target="_blank">
                                               <img src="images/logo-nagvis.png">
                                           </a>
                                       </div>
                                   </div>
                               </li>
                               <li>
                                    <a id="nagiosgraph_toggle" href="#">Nagios Graph</a>
                                    <div style="margin: 0px; position: static; overflow: hidden; height: 0px;">
                                       <div id="nagiosgraph" style="margin: -143px 0px 0px;">
                                           <a href="/nagiosgraph/cgi-bin/show.cgi" target="_blank">
                                               <img src="images/logo-nagiosgraph.png">
                                           </a>
                                       </div>
                                   </div>
                               </li>
                               <li>
                                    <a id="centreon_toggle" href="#">Centreon</a>
                                    <div style="margin: 0px; position: static; overflow: hidden; height: 0px;">
                                       <div id="centreon" style="margin: -143px 0px 0px;">
                                           <a href="##CENTREON##" target="_blank">
                                               <img src="images/logo-centreon.png">
                                           </a>
                                       </div>
                                   </div>
                               </li>
                               <li>
                                    <a id="dokuwiki_toggle" href="#">Doku Wiki</a>
                                    <div style="margin: 0px; position: static; overflow: hidden; height: 0px;">
                                       <div id="dokuwiki" style="margin: -143px 0px 0px;">
                                           <a href="##DOKUWIKI##" target="_blank">
                                               <img src="images/logo-dokuwiki.png">
                                           </a>
                                       </div>
                                   </div>
                               </li>
                               <li>Official Nagios plugins : plugins to monitor servers</li>
                               <li>Contrib Nagios plugins : plugins offer by Nagios community</li>
                               <br>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
