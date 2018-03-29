<?php

// MySQL
$mysqli = @new mysqli('localhost', 'root', 'rootv66');
$mysql_running = true;
if (mysqli_connect_errno()) {
    $mysql_running = false;
} else {
	$mysql_version = $mysqli->server_info;
}
$mysqli->close();

?>
<!doctype html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<title>Vagrant UbPHP7</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.0.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

    <style type="text/css">
        html, body { height: 100%; }

        table td:first-child {
            width: 300px;
        }
    </style>
</head>
<body>
	<div id="wrap">
		<div class="container">
			<div class="page-header">
				<h1 class="my-4"><i class="fa fa-trophy mr-2"></i> It works!</h1>
			</div>
			<p class="lead">The Virtual Machine is up and running, yay!</p>

			<section class="row">
				<div class="col-12">
					<h3 class="my-3">Installed software</h3>

					<table class="table table-bordered table-striped">
						<tr>
							<td>PHP Version</td>
							<td><?php echo phpversion(); ?></td>
						</tr>

						<tr>
							<td>MySQL running</td>
							<td><i class="fa fa-<?php echo ($mysql_running ? 'check' : 'times'); ?>"></i></td>
						</tr>

						<tr>
							<td>MySQL version</td>
							<td><?php echo ($mysql_running ? $mysql_version : 'N/A'); ?></td>
						</tr>
					</table>
				</div>
			</section>

			<section class="row">
				<div class="col-12">
					<h3 class="my-3">PHP Modules</h3>

					<table class="table table-bordered table-striped">
						<tr>
							<td>MySQL</td>
							<td><i class="fa fa-<?php echo (class_exists('mysqli') ? 'check' : 'times'); ?>"></i></td>
						</tr>

						<tr>
							<td>CURL</td>
							<td><i class="fa fa-<?php echo (function_exists('curl_init') ? 'check' : 'times'); ?>"></i></td>
						</tr>

						<tr>
							<td>mcrypt</td>
							<td><i class="fa fa-<?php echo (function_exists('mcrypt_encrypt') ? 'check' : 'times'); ?>"></i></td>
						</tr>
					</table>
				</div>
			</section>

			<section class="row">
				<div class="col-12">
					<h3 class="my-3">MySQL credentials</h3>

					<table class="table table-bordered table-striped">
						<tr>
							<td>Hostname</td>
							<td>localhost</td>
						</tr>

						<tr>
							<td>Username</td>
							<td>root</td>
						</tr>

						<tr>
							<td>Password</td>
							<td>rootv66</td>
						</tr>
						<tr>
							<td class="text-center" colspan="2">
								<a href="http://phpmyadmin.local.test">Go to PHPMyAdmin</a>
							</td>
						</tr>
					</table>
				</div>
			</section>

		</div>
	</div>
</body>
</html>