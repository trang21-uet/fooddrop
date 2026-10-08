import { createContext, useContext } from "react";

/** Lets the form know a photo upload is in flight, so saving does not drop a photo that is still uploading. */
export interface UploadActivity {
  begin: (count: number) => void;
  end: (count: number) => void;
}

const noop = () => {};

export const UploadActivityContext = createContext<UploadActivity>({ begin: noop, end: noop });

export const useUploadActivity = () => useContext(UploadActivityContext);
