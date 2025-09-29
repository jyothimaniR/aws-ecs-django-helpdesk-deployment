# AWS ECS Django Helpdesk Deployment

**Project 1** of my Cloud Portfolio - Production-grade deployment of Django Helpdesk application on AWS using ECS Fargate, RDS PostgreSQL, S3, and Infrastructure as Code with Terraform.

## 🏗️ Architecture

**Coming Soon**: Architecture diagram will be added after infrastructure is built.

## 📦 Application Source

This deployment uses the open-source [Django Helpdesk](https://github.com/django-helpdesk/django-helpdesk) application. The application code remains in its own repository, and this repo contains only the infrastructure and deployment code.

## 🛠️ Technology Stack

- **Application**: Django Helpdesk (referenced from forked repo)
- **Container Orchestration**: AWS ECS Fargate
- **Database**: AWS RDS PostgreSQL
- **Storage**: AWS S3
- **Container Registry**: AWS ECR
- **Monitoring**: AWS CloudWatch
- **Infrastructure as Code**: Terraform
- **CI/CD**: GitHub Actions
- **Authentication**: AWS OIDC (no stored credentials)

## 📊 Project Status

🚧 **Under Development**

- [x] Project structure setup
- [x] Tool installation (AWS CLI, Terraform, Docker)
- [ ] Local Docker development environment
- [ ] Terraform infrastructure modules
- [ ] GitHub Actions CI/CD pipeline
- [ ] CloudWatch monitoring & alarms
- [ ] Documentation & architecture diagram
- [ ] Video demo

## 💰 Cost Optimization

This project is designed to be cost-effective:
- **During development**: ~$15-25 total
- **After completion**: $0 (infrastructure destroyed)
- **For demo deployments**: ~$1-2 per deployment
- **Redeployment time**: 12-15 minutes

## 🚀 Quick Start

**Documentation coming soon** - Infrastructure is currently being built.

## 📝 Architecture Approach

This repository follows industry best practices by separating infrastructure code from application code:
- **This repo**: Infrastructure as Code (Terraform), deployment configs, CI/CD
- **Application repo**: Django Helpdesk application (forked from upstream)

The Docker build process automatically pulls the application code from the forked repository.

## 🎯 Learning Objectives

This project demonstrates:
- AWS ECS Fargate container orchestration
- RDS database management
- S3 storage integration
- Infrastructure as Code with Terraform
- CI/CD with GitHub Actions
- CloudWatch monitoring
- Security best practices (IAM, OIDC, Secrets Manager)
- Cost optimization strategies

## 📫 Contact

Part of my Cloud Portfolio showcasing AWS and DevOps skills.

---

**Note**: This is a portfolio project. The infrastructure can be deployed on-demand for demonstrations and then destroyed to minimize costs.
