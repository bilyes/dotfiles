local handles = {}

return {
  init_options = {
    supportsOperationNotifications = true,
  },
  handlers = {
    ["sorbet/showOperation"] = function(err, params, ctx)
      local ok, fidget_progress = pcall(require, "fidget.progress")
      if not ok then return end

      local key = params.operationName
      if params.status == "start" then
        handles[key] = fidget_progress.handle.create({
          title      = params.operationName,
          message    = params.description,
          lsp_client = { name = "sorbet" },
        })
      elseif params.status == "end" and handles[key] then
        handles[key]:finish()
        handles[key] = nil
      end
    end,
  },
}
