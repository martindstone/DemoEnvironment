  resource "aws_s3_bucket" "website" {
    bucket = var.bucketName
    acl = "public-read"

    force_destroy = true

    policy = <<POLICY
{
      "Version":"2008-10-17",
      "Statement":[{
      "Sid":"AllowPublicRead",
      "Effect":"Allow",
      "Principal": {"AWS": "*"},
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.bucketName}/*"]
      }]
  }
  POLICY


    website {
      index_document = "index.html"
      error_document = "error.html"
    }

    cors_rule {
      allowed_headers = [
        "*"]
      allowed_methods = [
        "HEAD",
        "GET",
        "DELETE",
        "PUT",
        "POST"]
      allowed_origins = [
        "*"]

    }
  }


  ///////////// Maybe have something there to alter the files?




  ///////////// Generate websites

  resource "null_resource" "folder" {

    count = length(var.users)

    provisioner "local-exec" {

      // replace DIR with where you save the DemoApp directory e.g. /Users/hliang/Desktop/DemoApp

      command = "aws s3 sync DIR s3://${aws_s3_bucket.website.id}/${var.users[count.index]}"
    }

  }


  //////////// 


  //// teams

  resource "pagerduty_team" "teams" {

    count = length(var.users)
    name = "${var.name[count.index]} phone shop"
    description = "managed by terraform"


  }

  ////// users

  resource "pagerduty_user" "users"{

    count = length(var.users)
    name = "${var.name[count.index]}"
    email = "${var.users[count.index]}@pagerduty.com"

  }

  //// team_membership

  resource "pagerduty_team_membership" "membership"{


    count = length(var.users)
    user_id = "${pagerduty_user.users[count.index].id}"
    team_id = "${pagerduty_team.teams[count.index].id}"

  }


  ////// EP's

  resource "pagerduty_escalation_policy" "escalationPolicy" {
    count = length(var.name)
    name = "${var.name[count.index]} Phone Shop EP"
    num_loops = 1
    teams = ["${pagerduty_team.teams[count.index].id}"]

    rule {
      escalation_delay_in_minutes = 10

      target {
        type = "user"
        id = "${pagerduty_user.users[count.index].id}"
      }

    }
  }


  ///// schedules


  //// services

  resource "pagerduty_service" "services" {

    count = length(var.users)
    name = "${var.users[count.index]} phone shop"
    auto_resolve_timeout = 14400
    escalation_policy = "${pagerduty_escalation_policy.escalationPolicy[count.index].id}"
    alert_creation = "create_alerts_and_incidents"
    alert_grouping = "time"
    alert_grouping_timeout = "5"

  }



          // service integration
  resource "pagerduty_service_integration" "integration" {

    count = length(var.users)
    name    = "Event V2"
    type    = "events_api_v2_inbound_integration"
    service = "${pagerduty_service.services[count.index].id}"

  }

  /// extensions?




  ///////// PD event rules P1 priotiy - P47CZYB

  resource "pagerduty_event_rule" "eventRules" {

    count = length(var.users)

    action_json = jsonencode([
    [
      "route",
      "${pagerduty_service.services[count.index].id}"
    ],
    [
      "severity",
      "critical"
      ],
    [
      "annotate",
      "Managed by terraform"
    ],
    [
      "priority",
      "${var.priority}"
    ]
    ])
    condition_json = jsonencode([
      "or",
      ["contains",["path", "SystemRoute"], "${var.users[count.index]}"],
      ["contains",["path", "details.SystemRoute"], "${var.users[count.index]}"]

    ])

  }



  /////////// build out dummy data




