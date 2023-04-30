<!DOCTYPE html>
<html lang="en">
	<head>
        <meta charset="UTF-8">
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="profile" href="http://gmpg.org/xfn/11">
		<link href = "{{{ asset('css/style.css') }}}" rel = "stylesheet" />
		<link href = "{{{ asset('css/skeleton.css') }}}" rel = "stylesheet" />
		<!-- <script src = "{{{ asset('js/jquery.min.js') }}}" type = "text/javascript"></script> -->
        <script src = "https://code.jquery.com/jquery-3.6.3.min.js"></script>
        <script src = "https://unpkg.com/vue@3"></script>
        
        <title>--website_title--</title>
    </head>
    <!-- LOGIN FORM would go here -->
	<div class = "banner">
		<div class = "banner-title">
				<h1>--website_banner_text--</h1>
		</div>
	</div>

	<div class = "sidebar">
			<ul>
				<!--<li><a href = "/events">Events</a></li> -->
                @admin
                    <li><a href = "/admin/">Admin</a></li>
                @endadmin
			</ul>
	</div>

	<body><div class = "content-main">
		@yield('content')
	</div></body>
</html>
