import type { RouteConfig } from '@asteasolutions/zod-to-openapi';
import { axios } from '../axios';
import { registerRoute, urlBuilder } from '../utils';
import { z } from '../zod';

export const UNSUBSCRIBE_EXPORT_LIST = '/unsubscribe/export-list/{baseId}';

export const exportUnsubscribeListRoute: RouteConfig = registerRoute({
  method: 'get',
  path: UNSUBSCRIBE_EXPORT_LIST,
  description: 'Export unsubscribe list',
  request: {
    params: z.object({
      baseId: z.string(),
    }),
  },
  responses: {
    200: {
      description: 'Export unsubscribe list successfully',
    },
  },
});

export const exportUnsubscribeList = async (baseId: string) => {
  return await axios.get(urlBuilder(UNSUBSCRIBE_EXPORT_LIST, { baseId }));
};
