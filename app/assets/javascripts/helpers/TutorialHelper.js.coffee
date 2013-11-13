Mywebroom.Helpers.TutorialHelper = {


  saveTutorialStep:(user_id,tutorial_step) ->


    # Persist new tutorial step to server
    updateUsersProfile = new Mywebroom.Models.UpdateUsersProfilesTutorialStepByUserIdAndTutorialStepModel({_id: user_id})
    updateUsersProfile.user_id = user_id
    updateUsersProfile.tutorial_step = tutorial_step
    updateUsersProfile.save
      wait: true
    ,
      success: (model, response) ->
        console.log(" SAVE tutorial Step "+tutorial_step+" SUCCESS\n", response)

        error: (model, response) ->
          console.log("Tutorial Step "+tutorial_step+" SAVE FAIL\n", response)
}