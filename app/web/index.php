<?php
function GetConfigVariable($variable)
{
	$this_file_path = __DIR__;
	$main_conf_path = "/bin/bash {$this_file_path}/get_config_variable.sh";
	$cmd = "{$main_conf_path} '{$variable}' 2>/dev/null";
	$value = shell_exec($cmd);
	return $value;
}

function Unauthorized()
{
	header('WWW-Authenticate: Basic realm="Test Authentication System"');
	header('HTTP/1.0 401 Unauthorized');
	echo "You must enter a valid login ID and password to access this resource\n";
	exit;
}

if (!isset($_SERVER['PHP_AUTH_USER'])) {
	Unauthorized();
} else {
	session_start();
	$web_username = GetConfigVariable("web_username");
	$web_password = GetConfigVariable("web_password");
	if ($_SERVER['PHP_AUTH_USER'] == $web_username && $_SERVER['PHP_AUTH_PW'] == $web_password) {
		$_SESSION['logged_in_user'] = $_SERVER['PHP_AUTH_USER'];
	} else {
		Unauthorized();
	}
}

### print ui if logged in
if (isset($_SESSION['logged_in_user'])) {

	### Handle Actions
	if (isset($_POST['action'])) {
		$action = $_POST['action'];
		if (
			$action == "reboot_system" ||
			$action == "restart_mining"
		) {
			$web_pipe_file_path = GetConfigVariable("web_pipe_file_path");
			$web_pipe_file = fopen($web_pipe_file_path, "w");
			fwrite($web_pipe_file, $action);
			fclose($web_pipe_file);
		} else {
			print "No Action";
			exit;
		}
	}

	### get variables from config
	$current_hashrate_log_path = GetConfigVariable("current_hashrate_log_path");
	$reported_hashrate_log_path = GetConfigVariable("reported_hashrate_log_path");
	$avg_hashrate_log_path = GetConfigVariable("avg_hashrate_log_path");
	$balance_log_path = GetConfigVariable("balance_log_path");
	$last_balance_path = GetConfigVariable("last_balance_path");
	$check_network_log_path = GetConfigVariable("check_network_log_path");
	$mine_log_path = GetConfigVariable("mine_log_path");
	$mining_log_path = GetConfigVariable("mining_log_path");
	$mining_old_log_path = GetConfigVariable("mining_old_log_path");
	$pool = GetConfigVariable("pool");
	$web_title = GetConfigVariable("web_title");
	$web_address = GetConfigVariable("web_address");

	### get system logs
	$current_hashrate = shell_exec("tail -n 288 {$current_hashrate_log_path} | tac");
	$reported_hashrate = shell_exec("tail -n 288 {$reported_hashrate_log_path} | tac");
	$avg_hashrate = shell_exec("tail -n 100 {$avg_hashrate_log_path} | tac");
	$balance = shell_exec("tail -n 100 {$balance_log_path} | tac");
	$check_network = shell_exec("tail -n 300 {$check_network_log_path} | tac");
	$mine = shell_exec("tail -n 100 {$mine_log_path} | tac");
	$mining = shell_exec("tail -n 300 {$mining_log_path} | tac");
	$mining_old = shell_exec("tail -n 300 {$mining_old_log_path} | tac");
	$number_of_days = shell_exec("wc -l {$balance_log_path} | awk {'print $1'} | tr -d '\n'");
	$number_of_cards = shell_exec("ls /sys/class/drm/ | egrep 'card[0-9]$' | wc -l | tr -d '\n'");

	### get total balance from pool
	$total_balance = 0;

	if ($pool == "nanopool.org") {
		$pool_wallet_id = GetConfigVariable("pool_wallet_id");
		$url = "https://api.nanopool.org/v1/eth/balance/{$pool_wallet_id}";
		ini_set('default_socket_timeout', 4);
		$json = file_get_contents($url);
		$json = json_decode($json, false);
		$total_balance = $json->data;
		if ($total_balance == "null" || $total_balance == "") {
			$total_balance = "error";
		}
	} elseif ($pool == "miningpoolhub.com") {
		$pool_api_key = GetConfigVariable("pool_api_key");
		$url = "https://ethereum.miningpoolhub.com/index.php?page=api&action=getuserbalance&api_key={$pool_api_key}";
		ini_set('default_socket_timeout', 4);
		$json = file_get_contents($url);
		$json = json_decode($json, false);
		$total_balance = $json->getuserbalance->data->confirmed;
		if ($total_balance == "null" || $total_balance == "") {
			$total_balance = "error";
		}
	} elseif ($pool == "ethermine.org") {
		$pool_wallet_id = GetConfigVariable("pool_wallet_id");
		$url = "https://api.ethermine.org/miner/{$pool_wallet_id}/currentStats";
		ini_set('default_socket_timeout', 4);
		$json = file_get_contents($url);
		$json = json_decode($json, false);
		if ($json->status == "OK") {
			$total_balance = $json->data->unpaid;
			$total_balance =  (float) sprintf("%.8f", $total_balance / 1000000000000000000);
		} else {
			$total_balance = "error";
		}
	} else { ### not implemented other pools yet
		$total_balance = "error";
	}

	### get last balance
	$last_balance = shell_exec("cat {$last_balance_path}");

	### calc last 24H balance
	if ($total_balance == "error" || $total_balance < $last_balance) {
		$last24h_balance = "unknown";
	} else {
		$last24h_balance = $total_balance - $last_balance;
	}

?>
	<!DOCTYPE html>
	<html lang="en">

	<head>
		<title><?= $web_title ?></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="shortcut icon" href="resource/image/favicon.ico" />
		<link rel="icon" type="image/x-icon" href="resource/image/favicon.ico" />

		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

		<style>
			html,
			body {
				height: 100%;
			}

			.wrap {
				min-height: 100%;
				height: auto;
				margin: 0 auto -60px;
				padding: 0 0 60px;
			}

			.wrap>.container-fluid {
				padding: 70px 15px 20px;
			}

			.footer {
				height: 60px;
				background-color: #101010;
				padding-top: 20px;
			}

			.table td.fit,
			.table th.fit {
				white-space: nowrap;
				width: 1%;
			}
		</style>
	</head>

	<body>
		<div class="wrap">
			<nav class="navbar navbar-inverse navbar-fixed-top">
				<div class="container-fluid">
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
						<a class="navbar-brand" href="<?= $web_address ?>"><?= $web_title ?></a>
					</div>
					<ul class="nav navbar-nav">
					</ul>
				</div>
			</nav>
			<div class="container-fluid">

				<div class="row">
					<div class="col-sm-1"></div>
					<div class="col-sm-10">
						<div class="panel panel-default">
							<div class="panel-heading">Quick Access</div>
							<div class="panel-body">
								<div class="alert alert-info">
									<strong><?= $number_of_cards ?> GPUs</strong>
								</div>
								<div class="btn-group">
									<form method="post" action="./">
										<input type="hidden" name="action" value="reboot_system" />
										<input type="submit" class="btn btn-danger" value="Reboot System" onclick="return confirm('Are you sure?')">
									</form>
								</div>
								<div class="btn-group">
									<form method="post" action="./">
										<input type="hidden" name="action" value="restart_mining" />
										<input type="submit" class="btn btn-danger" value="Restart Mining" onclick="return confirm('Are you sure?')">
									</form>
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-1"></div>
				</div>

				<div class="row">
					<div class="col-sm-1"></div>
					<div class="col-sm-10">
						<ul class="nav nav-tabs">
							<li class="active"><a data-toggle="tab" href="#menu1">Current Hashrate</a></li>
							<li><a data-toggle="tab" href="#menu2">Reported Hashrate</a></li>
							<li><a data-toggle="tab" href="#menu3">Avg Hashrate</a></li>
							<li><a data-toggle="tab" href="#menu4">Balance</a></li>
							<li><a data-toggle="tab" href="#menu5">Network</a></li>
							<li><a data-toggle="tab" href="#menu6">Mine</a></li>
							<li><a data-toggle="tab" href="#menu7">Mining</a></li>
							<li><a data-toggle="tab" href="#menu8">Mining Old</a></li>
						</ul>

						<div class="tab-content">
							<div id="menu1" class="tab-pane fade in active">
								<h3>Current Hashrate</h3>
								<pre><?= $current_hashrate ?></pre>
							</div>
							<div id="menu2" class="tab-pane fade">
								<h3>Reported Hashrate</h3>
								<pre><?= $reported_hashrate ?></pre>
							</div>
							<div id="menu3" class="tab-pane fade">
								<h3>Avg Hashrate</h3>
								<pre><?= $avg_hashrate ?></pre>
							</div>
							<div id="menu4" class="tab-pane fade">
								<h3>Balance</h3>
								<h5>Number Of Days: <?= $number_of_days ?> days</h5>
								<h5>TotaL Balance: <?= $total_balance ?></h5>
								<h5>L 24h Balance: <?= $last24h_balance ?></h5>
								<pre><?= $balance ?></pre>
							</div>
							<div id="menu5" class="tab-pane fade">
								<h3>Network</h3>
								<pre><?= $check_network ?></pre>
							</div>
							<div id="menu6" class="tab-pane fade">
								<h3>Mine</h3>
								<pre><?= $mine ?></pre>
							</div>
							<div id="menu7" class="tab-pane fade">
								<h3>Mining</h3>
								<pre><?= $mining ?></pre>
							</div>
							<div id="menu8" class="tab-pane fade">
								<h3>Mining Old</h3>
								<pre><?= $mining_old ?></pre>
							</div>

						</div>
					</div>
					<div class="col-sm-1"></div>
				</div>
			</div>
		</div>
		<footer class="footer">
			<div class="container-fluid">
				<div class="text-center">
					<p style="color: #fff;">
						Copyright &#9400; 2019 Armin Mokri
					</p>
				</div>
			</div>
		</footer>
	</body>

	</html>
<?php
}
?>