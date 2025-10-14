import type { RouteConfig } from '@asteasolutions/zod-to-openapi';
import { notifyVoSchema } from '../attachment';
import { axios } from '../axios';
import { registerRoute, urlBuilder } from '../utils';
import { z } from '../zod';

export const UNSUBSCRIBE_IMPORT_LIST = '/unsubscribe/import-list/{baseId}';

export const importUnsubscribeListRoSchema = z.object({
  notify: notifyVoSchema,
});

export type ImportUnsubscribeListRo = z.infer<typeof importUnsubscribeListRoSchema>;

export const importUnsubscribeListRoute: RouteConfig = registerRoute({
  method: 'post',
  path: UNSUBSCRIBE_IMPORT_LIST,
  description: 'Import unsubscribe list',
  request: {
    params: z.object({
      baseId: z.string(),
    }),
    body: {
      content: {
        'application/json': {
          schema: importUnsubscribeListRoSchema,
        },
      },
    },
  },
  responses: {
    200: {
      description: 'Import unsubscribe list',
      content: {
        'application/json': {
          schema: z.boolean(),
        },
      },
    },
  },
});

export const importUnsubscribeList = async (
  baseId: string,
  importUnsubscribeListRo: ImportUnsubscribeListRo
) => {
  return await axios.post(urlBuilder(UNSUBSCRIBE_IMPORT_LIST, { baseId }), importUnsubscribeListRo);
};
