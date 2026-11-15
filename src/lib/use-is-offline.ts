import { useNetInfo } from "@react-native-community/netinfo";

/** True only when the OS reports no connection or no reachable internet. */
export const useIsOffline = (): boolean => {
  const { isConnected, isInternetReachable } = useNetInfo();
  return isConnected === false || isInternetReachable === false;
};
