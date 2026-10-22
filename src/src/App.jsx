
import { useState } from "react";
import "./App.css";

const initialScans = [
  { name: "SonarQube", detail: "Code quality analysis", status: "Passed" },
  { name: "Trivy", detail: "Container vulnerability scan", status: "Passed" },
  { name: "Docker Build", detail: "Container image creation", status: "Passed" },
];

const pipeline = [
  { title: "Source checkout", detail: "GitHub repository", time: "09:10 AM", status: "Success" },
  { title: "Code quality", detail: "SonarQube analysis", time: "09:11 AM", status: "Success" },
  { title: "Image security scan", detail: "Trivy scanner", time: "09:12 AM", status: "Success" },
  { title: "Container deployment", detail: "Kubernetes / EKS", time: "09:14 AM", status: "Demo" },
];

function Icon({ name }) {
  const icons = {
    grid: "▦",
    cloud: "☁",
    shield: "⬡",
    activity: "⌁",
    settings: "⚙",
    check: "✓",
    arrow: "↗",
    clock: "◷",
    server: "▤",
    code: "</>",
  };

  return <span className="icon" aria-hidden="true">{icons[name] || "•"}</span>;
}

function App() {
  const [activePage, setActivePage] = useState("Overview");
  const [scans, setScans] = useState(initialScans);
  const [notice, setNotice] = useState("");

  const pages = [
    { name: "Overview", icon: "grid" },
    { name: "Infrastructure", icon: "cloud" },
    { name: "Security", icon: "shield" },
    { name: "Monitoring", icon: "activity" },
  ];

  function runDemoScan() {
    setScans([
      { name: "SonarQube", detail: "Code quality analysis", status: "Passed" },
      { name: "Trivy", detail: "Container vulnerability scan", status: "Passed" },
      { name: "Docker Build", detail: "Container image creation", status: "Running" },
    ]);
    setNotice("Demo pipeline started. Real scanning will be connected through GitHub Actions.");
  }

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-mark"><Icon name="shield" /></div>
          <div>
            <h2>CloudShield</h2>
            <span>DEVSECOPS PLATFORM</span>
          </div>
        </div>

        <p className="nav-label">WORKSPACE</p>
        <nav>
          {pages.map((page) => (
            <button
              key={page.name}
              className={`nav-item ${activePage === page.name ? "active" : ""}`}
              onClick={() => {
                setActivePage(page.name);
                setNotice("");
              }}
            >
              <Icon name={page.icon} />
              {page.name}
            </button>
          ))}
        </nav>

        <div className="sidebar-bottom">
          <div className="environment-dot" />
          <div>
            <strong>AWS Environment</strong>
            <span>ap-south-1 · Mumbai</span>
          </div>
        </div>
      </aside>

      <main className="main-content">
        <header className="topbar">
          <div>
            <span className="breadcrumb">CloudShield /</span>
            <strong>{activePage}</strong>
          </div>
          <div className="demo-label"><span /> DEMO ENVIRONMENT</div>
        </header>

        <section className="page-heading">
          <div>
            <p className="eyebrow">CLOUD SECURITY & DELIVERY</p>
            <h1>{activePage === "Overview" ? "Security overview" : activePage}</h1>
            <p className="subtitle">
              A central view of your cloud infrastructure, security and delivery pipeline.
            </p>
          </div>
          <button className="primary-button" onClick={runDemoScan}>
            <Icon name="arrow" /> Run demo pipeline
          </button>
        </section>

        {notice && <div className="notice" role="status">{notice}</div>}

        {activePage === "Overview" && (
          <>
            <section className="stats-grid">
              <StatCard label="Infrastructure" value="4 / 4" note="Demo resources available" icon="cloud" />
              <StatCard label="Security checks" value="3 / 3" note="Demo checks passed" icon="shield" />
              <StatCard label="Deployments" value="12" note="Illustrative total" icon="code" />
              <StatCard label="Availability" value="99.9%" note="Illustrative metric" icon="activity" />
            </section>

            <section className="content-grid">
              <div className="panel pipeline-panel">
                <div className="panel-heading">
                  <div>
                    <h3>Pipeline activity</h3>
                    <p>Latest example workflow</p>
                  </div>
                  <span className="status-pill success">DEMO SUCCESS</span>
                </div>

                <div className="pipeline-list">
                  {pipeline.map((step, index) => (
                    <div className="pipeline-step" key={step.title}>
                      <div className={`step-icon ${step.status === "Demo" ? "neutral" : ""}`}>
                        {step.status === "Demo" ? <Icon name="clock" /> : <Icon name="check" />}
                      </div>
                      <div className="step-info">
                        <strong>{step.title}</strong>
                        <span>{step.detail}</span>
                      </div>
                      <div className="step-meta">
                        <span className={`small-status ${step.status === "Demo" ? "neutral-text" : ""}`}>
                          {step.status}
                        </span>
                        <time>{step.time}</time>
                      </div>
                    </div>
                  ))}
                </div>
                <p className="panel-footnote">
                  Example activity only. Connect GitHub Actions for actual workflow results.
                </p>
              </div>

              <div className="panel">
                <div className="panel-heading">
                  <div>
                    <h3>Security checks</h3>
                    <p>Example tool results</p>
                  </div>
                  <span className="status-pill success">3 PASSED</span>
                </div>

                <div className="scan-list">
                  {scans.map((scan) => (
                    <div className="scan-row" key={scan.name}>
                      <div className="scan-icon"><Icon name="shield" /></div>
                      <div className="scan-info">
                        <strong>{scan.name}</strong>
                        <span>{scan.detail}</span>
                      </div>
                      <span className={`status-pill ${scan.status === "Running" ? "running" : "success"}`}>
                        {scan.status}
                      </span>
                    </div>
                  ))}
                </div>
                <p className="panel-footnote">
                  These statuses are simulated, not results from SonarQube or Trivy.
                </p>
              </div>
            </section>

            <section className="panel monitoring-panel">
              <div className="panel-heading">
                <div>
                  <h3>Infrastructure monitoring</h3>
                  <p>Illustrative metrics for the dashboard preview</p>
                </div>
                <span className="status-pill neutral-pill">NOT LIVE</span>
              </div>

              <div className="metrics-grid">
                <Metric label="CPU utilization" value="34%" percent={34} />
                <Metric label="Memory utilization" value="61%" percent={61} />
                <Metric label="Container health" value="4 / 4" percent={100} />
                <Metric label="Application health" value="Healthy" percent={100} />
              </div>
              <p className="panel-footnote">
                Live metrics will require Prometheus exporters and application monitoring.
              </p>
            </section>
          </>
        )}

        {activePage === "Infrastructure" && (
          <section className="panel detail-panel">
            <h3>AWS infrastructure</h3>
            <p className="subtitle">Planned resources for the CloudShield environment.</p>
            <Resource name="VPC and subnets" description="Network isolation across availability zones" status="Terraform managed" />
            <Resource name="EC2 agent" description="Self-hosted DevOps tools and automation" status="Check actual status" />
            <Resource name="Amazon ECR" description="Container image registry" status="Provisioning required" />
            <Resource name="Amazon EKS" description="Kubernetes application deployment" status="Provisioning required" />
          </section>
        )}

        {activePage === "Security" && (
          <section className="panel detail-panel">
            <h3>Security center</h3>
            <p className="subtitle">The real pipeline will populate these checks after each code push.</p>
            {scans.map((scan) => (
              <Resource key={scan.name} name={scan.name} description={scan.detail} status={scan.status} />
            ))}
            <div className="notice">
              Do not treat demo statuses as verified security results. Configure actual scans before submission.
            </div>
          </section>
        )}

        {activePage === "Monitoring" && (
          <section className="panel detail-panel">
            <h3>Monitoring center</h3>
            <p className="subtitle">Prometheus collects metrics; Grafana visualizes them.</p>
            <div className="metrics-grid">
              <Metric label="CPU utilization" value="34%" percent={34} />
              <Metric label="Memory utilization" value="61%" percent={61} />
              <Metric label="Container health" value="4 / 4" percent={100} />
              <Metric label="Application health" value="Healthy" percent={100} />
            </div>
            <p className="panel-footnote">
              Example values only. Connect real data sources before using these metrics for operational decisions.
            </p>
          </section>
        )}

        <footer className="footer">
          <span>CloudShield DevSecOps Hackathon 2026</span>
          <span>React · AWS · Terraform · GitHub Actions</span>
        </footer>
      </main>
    </div>
  );
}

function StatCard({ label, value, note, icon }) {
  return (
    <article className="stat-card">
      <div className="stat-top">
        <span>{label}</span>
        <div className="stat-icon"><Icon name={icon} /></div>
      </div>
      <strong className="stat-value">{value}</strong>
      <span className="stat-note">{note}</span>
    </article>
  );
}

function Metric({ label, value, percent }) {
  return (
    <div className="metric">
      <div className="metric-label">{label}</div>
      <strong>{value}</strong>
      <div className="meter">
        <div style={{ width: `${percent}%` }} />
      </div>
    </div>
  );
}

function Resource({ name, description, status }) {
  return (
    <div className="resource-row">
      <div className="resource-icon"><Icon name="server" /></div>
      <div className="resource-info">
        <strong>{name}</strong>
        <span>{description}</span>
      </div>
      <span className="resource-status">{status}</span>
    </div>
  );
}

export default App;
