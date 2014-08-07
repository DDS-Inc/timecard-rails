class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects': 'index'
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->
    @projects = new Timecard.Collections.Projects
    @issues = new Timecard.Collections.Issues
    @comments = new Timecard.Collections.Comments
    @workloads = new Timecard.Collections.Workloads

  index: ->
    return if $('.login').hasClass('false')
    return if $('.home').length is 0
    @issues.project_id = null
    @issues.url = '/api/my/issues'
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(
      projects: @projects
      issues: @issues
      comments: @comments
      workloads: @workloads
      router: @
    )
    @viewHomeSidebar.render()
    @viewHomeMain = new Timecard.Views.HomeMain(
      projects: @projects
      issues: @issues
      workloads: @workloads
    )
    @viewHomeMain.render()
    @renderGlobalTimer()

  show: (id) ->
    return if $('.home').length is 0
    @issues.project_id = id
    @issues.url = '/api/my/projects/'+id+'/issues'
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(
      projects: @projects
      issues: @issues
      comments: @comments
      workloads: @workloads
      router: @
    )
    @viewHomeSidebar.render()
    @viewHomeMain = new Timecard.Views.HomeMain(
      projects: @projects
      issues: @issues
      workloads: @workloads
    )
    @viewHomeMain.render()
    @renderGlobalTimer()

  renderGlobalTimer: ->
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        workload = workloads.findWhere(end_at: null)
        if workload?
          @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: workload, issues: @issues)
          @viewWorkloadsTimer.render()
