/* eslint-disable max-len */
import * as admin from "firebase-admin";
import { onCall } from "firebase-functions/v2/https";

admin.initializeApp();

interface RecipeStepData {
  recipeId: string;
  currentStep: number;
  totalSteps: number;
}

export const trackRecipeStep = onCall<RecipeStepData>({
  region: "us-central1",
}, async (request) => {
  console.log("Function called with request:", request);

  if (!request.data) {
    throw new Error("No data provided in request");
  }

  try {
    const { recipeId, currentStep, totalSteps } = request.data;

    // Validate input
    if (!recipeId ||
        typeof currentStep !== "number" ||
        typeof totalSteps !== "number") {
      console.error("Invalid input:", { recipeId, currentStep, totalSteps });
      throw new Error(
        "Missing required fields: recipeId, currentStep, totalSteps");
    }

    // Update the recipe's progress
    const recipeRef = admin.firestore()
      .collection("recipes")
      .doc(recipeId);

    await recipeRef.update({
      progress: currentStep,
      lastUpdated: admin.firestore.Timestamp.now(),
    });

    return {
      success: true,
      progress: currentStep,
      totalSteps,
    };
  } catch (error: unknown) {
    console.error("Error in trackRecipeStep:", error);
    const errorMessage = error instanceof Error ? error.message :
      "Unknown error";
    throw new Error(`Failed to update recipe progress: ${errorMessage}`);
  }
});
