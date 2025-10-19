locals {
  tags = {
    Project     = var.project_name
    Environment = "dev"
    ManagedBy   = "terraform"
  }

  demo_html_template = <<-EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AWS ECS Fargate Capacity Provider Demo</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: #ffffff;
            min-height: 100vh;
            line-height: 1.6;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255,255,255,0.95);
            color: #333;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1e3c72;
            text-align: center;
            margin-bottom: 40px;
            font-size: 2.8em;
            font-weight: 700;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
            margin: 40px 0;
        }
        .info-card {
            background: #f8f9fa;
            padding: 24px;
            border-radius: 8px;
            border-left: 4px solid #007bff;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .info-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .info-card h3 {
            color: #1e3c72;
            margin-top: 0;
            font-size: 1.4em;
            font-weight: 600;
            margin-bottom: 16px;
        }
        .status {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 20px;
            font-weight: 600;
            margin: 4px 8px 4px 0;
            font-size: 0.9em;
        }
        .status.healthy {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status.running {
            background: #cce7ff;
            color: #004085;
            border: 1px solid #b3d7ff;
        }
        .capacity-info {
            background: #e3f2fd;
            padding: 24px;
            border-radius: 8px;
            margin: 32px 0;
            border: 2px solid #2196f3;
        }
        .capacity-provider {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px;
            margin: 12px 0;
            background: #ffffff;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
        }
        .provider-name {
            font-weight: 600;
            color: #1e3c72;
            font-size: 1.1em;
        }
        .provider-details {
            font-size: 0.9em;
            color: #666;
            margin-top: 4px;
        }
        .footer {
            text-align: center;
            margin-top: 40px;
            color: #666;
            font-size: 0.9em;
        }
        .timestamp {
            color: #007bff;
            font-weight: 600;
        }
        .demo-actions {
            background: #f8f9fa;
            padding: 24px;
            border-radius: 8px;
            margin: 32px 0;
            border: 1px solid #e9ecef;
        }
        .demo-actions h3 {
            color: #1e3c72;
            margin-top: 0;
            font-size: 1.3em;
            margin-bottom: 16px;
        }
        .demo-actions ul {
            color: #333;
            margin: 0;
            padding-left: 20px;
        }
        .demo-actions li {
            margin: 12px 0;
        }
        .code {
            background: #f1f3f4;
            padding: 3px 8px;
            border-radius: 4px;
            font-family: 'SF Mono', 'Monaco', 'Cascadia Code', monospace;
            color: #d63384;
            font-size: 0.9em;
            border: 1px solid #e0e0e0;
        }
        .info-card p {
            margin: 8px 0;
            color: #555;
        }
        .info-card strong {
            color: #1e3c72;
        }
        .capacity-info h3 {
            color: #1e3c72;
            margin-top: 0;
            font-size: 1.3em;
        }
        .capacity-info p {
            color: #555;
            margin-top: 16px;
        }
        a {
            color: #007bff;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 AWS ECS Fargate Capacity Provider Demo</h1>

        <div class="info-grid">
            <div class="info-card">
                <h3>📊 Service Status</h3>
                <div class="status healthy">✅ Healthy</div>
                <div class="status running">🔄 Running</div>
                <p><strong>Task Definition:</strong> ecs-fargate-demo-task:5</p>
                <p><strong>Container:</strong> nginx:alpine</p>
                <p><strong>Region:</strong> ap-southeast-2</p>
            </div>

            <div class="info-card">
                <h3>🔒 Security Features</h3>
                <p><strong>IP Restriction:</strong> ALB restricted to your public IP</p>
                <p><strong>Security Groups:</strong> Hardened with least privilege</p>
                <p><strong>VPC:</strong> Private subnets for ECS tasks</p>
                <p><strong>Logging:</strong> Comprehensive CloudWatch logs</p>
            </div>

            <div class="info-card">
                <h3>📈 Monitoring</h3>
                <p><strong>ECS Logs:</strong> /ecs/ecs-fargate-demo</p>
                <p><strong>ALB Logs:</strong> /aws/applicationloadbalancer/ecs-fargate-demo</p>
                <p><strong>VPC Flow Logs:</strong> /aws/vpc/flowlogs/ecs-fargate-demo</p>
                <p><strong>Health Check:</strong> <a href="/health">/health</a></p>
            </div>
        </div>

        <div class="capacity-info">
            <h3>⚡ Capacity Provider Strategy</h3>
            <div class="capacity-provider">
                <div>
                    <div class="provider-name">FARGATE (Standard)</div>
                    <div class="provider-details">Base capacity: 1 task | Weight: 1</div>
                </div>
                <div style="text-align: right;">
                    <div style="color: #28a745; font-weight: 600;">✓ Active</div>
                </div>
            </div>
            <div class="capacity-provider">
                <div>
                    <div class="provider-name">FARGATE_SPOT</div>
                    <div class="provider-details">Scaling capacity: 4x weight | Cost-optimized</div>
                </div>
                <div style="text-align: right;">
                    <div style="color: #28a745; font-weight: 600;">✓ Active</div>
                </div>
            </div>
            <p>
                <strong>How it works:</strong> The service uses FARGATE for baseline capacity (1 task) and FARGATE_SPOT for scaling (4x weight).
                When you scale up, new tasks will primarily use FARGATE_SPOT for cost optimization.
            </p>
        </div>

        <div class="demo-actions">
            <h3>🎯 Demo Actions</h3>
            <ul>
                <li><strong>Scale Up:</strong> Run <span class="code">terraform apply -var='desired_count=6'</span></li>
                <li><strong>Monitor Scaling:</strong> Check ECS Console → Service → Tasks</li>
                <li><strong>View Logs:</strong> CloudWatch → Log groups → /ecs/ecs-fargate-demo</li>
                <li><strong>Check Capacity Providers:</strong> ECS Console → Cluster → Capacity Providers</li>
                <li><strong>Cost Analysis:</strong> AWS Cost Explorer → Filter by ECS service</li>
            </ul>
        </div>

        <div class="footer">
            <p>🕒 Last updated: <span class="timestamp" id="timestamp"></span></p>
            <p>This demo showcases AWS ECS Fargate capacity providers for cost-optimized container scaling</p>
        </div>
    </div>

    <script>
        // Update timestamp
        document.getElementById('timestamp').textContent = new Date().toLocaleString();

        // Auto-refresh every 30 seconds to show live updates
        setTimeout(() => {
            location.reload();
        }, 30000);
    </script>
</body>
</html>
EOF
}
