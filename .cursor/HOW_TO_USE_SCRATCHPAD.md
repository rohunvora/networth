# How to Use the Scratchpad

## Purpose
The scratchpad.md is your planning headquarters. Before writing any code, document your thinking here.

## Workflow

### 1. When You Get a Feature Request
1. Open `.cursor/scratchpad.md`
2. Copy the Feature Analysis Template
3. Fill it out completely
4. Make a decision: Proceed/Defer/Reject

### 2. Before Starting Implementation
1. Break down tasks to < 4 hour chunks
2. Define clear success criteria
3. Identify risks and mitigation strategies
4. Get approval if needed

### 3. During Development
1. Check off completed tasks
2. Update time estimates with actuals
3. Document any surprises or blockers
4. Revise plan if scope changes

### 4. After Completion
1. Move completed features to "Completed Features"
2. Update progress tracking
3. Add any new technical debt discovered
4. Plan next immediate steps

## Best Practices

### Task Breakdown
❌ Bad: "Implement Plaid integration"
✅ Good: 
- "Research Plaid API requirements (1 hour)"
- "Create PlaidService.swift with auth flow (2 hours)"
- "Add Plaid UI to settings (1 hour)"
- "Test with sandbox account (1 hour)"

### Success Criteria
❌ Bad: "Charts should work"
✅ Good:
- "Chart shows last 30 days of net worth"
- "Updates when new data arrives"
- "Handles empty data gracefully"
- "Loads in < 0.5 seconds"

### Decision Making
Always consider:
1. **User value** - Does this make the "one number" better?
2. **Complexity** - What's the simplest solution?
3. **Time** - Can we ship something useful today?
4. **Maintenance** - Will this create ongoing work?

## Example Decision Flow

**Request**: "Add cryptocurrency portfolio tracking"

**Quick Assessment**:
- User value: HIGH (many users have crypto)
- Complexity: MEDIUM (need API integration)
- Time: 1-2 days for basic version
- Maintenance: LOW (prices auto-update)

**Decision**: Proceed with MVP version:
- Start with top 10 cryptocurrencies
- Use CoinGecko free API
- Manual wallet address entry
- Ship basic version, iterate based on feedback

## Red Flags to Watch For

🚨 **Over-engineering Alert**:
- Planning more than 3 days ahead
- Adding "nice to have" features to tasks
- Building generic systems vs solving specific problems
- Optimizing before measuring

🚨 **Scope Creep Alert**:
- "While we're at it..."
- "It would be cool if..."
- "Just one more thing..."
- Feature additions mid-implementation

## Weekly Review Checklist

Every week, update the scratchpad:
- [ ] Mark completed tasks
- [ ] Update time estimates with actuals
- [ ] Move completed features to done
- [ ] Identify top 3 tasks for next week
- [ ] Review and close fixed bugs
- [ ] Add any new technical debt
- [ ] Celebrate wins! 🎉

Remember: The scratchpad is a living document. Keep it updated, keep it honest, and keep it focused on shipping value to users. 